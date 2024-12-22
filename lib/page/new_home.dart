import 'package:ecg/page/account_settings.dart';
import 'package:ecg/page/heart_attack_prediction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health/health.dart';
import 'package:real_time_chart/real_time_chart.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io' show Platform;
import '../components/logged_in_navbar.dart';
import '../components/text_button.dart';
import '../components/alert_dialog.dart';
import '../model/ecg_data.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import './my_home_page.dart';
import './pregnancy_gender_prediction_page.dart';

class NewHome extends StatefulWidget {
  const NewHome({
    super.key,
  });

  @override
  State<NewHome> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHome> {
  // COMMON COMPONENTS
  TextStyle headerTextStyle = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  TextStyle focusTextStyle = const TextStyle(
    color: Colors.red,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  TextStyle infoTextStyle = TextStyle(
    fontFamily: Platform.isIOS ? 'sans_serif' : 'monospace',
    fontSize: Platform.isIOS ? 17 : 16,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  TextStyle fieldTextStyle = TextStyle(
    fontFamily: Platform.isIOS ? 'sans_serif' : 'monospace',
    fontSize: Platform.isIOS ? 19 : 18,
    fontWeight: FontWeight.w600,
    color: Colors.blue,
  );

  TextStyle errorTextStyle = TextStyle(
    fontFamily: Platform.isIOS ? 'sans_serif' : 'monospace',
    fontSize: Platform.isIOS ? 19 : 18,
    fontWeight: FontWeight.w600,
    color: Colors.red,
  );

  TextStyle heroHeaderTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.normal,
  );

  TextStyle heroCaptionTextStyle = const TextStyle(
    color: Colors.grey,
    fontSize: 16,
    height: 1.25,
  );

  List<HealthDataPoint> _healthData = [];
  HealthDataPoint? _selectedDataPoint;
  List<ECGData> _data = [];
  int _tid = 0;
  late int anomaly;
  String _status = '';
  String _ecgDataTimeRange = '';
  List<double> _voltages = [];
  List<double> _clippedVoltages = [];
  final Health _health = Health();
  final List<HealthDataType> _types = [HealthDataType.ELECTROCARDIOGRAM];
  late DateTime now;
  late DateTime start;
  late Interpreter _anomalyInterpreter;
  late Tensor _anomalyInputTensor;
  late Tensor _anomalyOutputTensor;

  Stream<double> nextDataStream() {
    return Stream.periodic(const Duration(milliseconds: 4), (_) {
      if (_data.isEmpty) return 0.0;
      if (_tid >= _data.length) {
        _tid = 0;
      }
      return _data[_tid++].voltage;
    }).asBroadcastStream();
  }

  void loadAnomalyInterpreter() {
    tfl.Interpreter.fromAsset('assets/anomaly.tflite').then((value) {
      _anomalyInterpreter = value;
      _anomalyInputTensor = _anomalyInterpreter.getInputTensors().first;
      _anomalyOutputTensor = _anomalyInterpreter.getOutputTensors().first;
      // debugPrint('Input Tensor Type: ${_anomalyInputTensor.type}');
      // debugPrint('Input Tensor Shape: ${_anomalyInputTensor.shape}');
      // debugPrint(
      //     'Input Tensor Data (first 10 values): ${(_anomalyInputTensor.data as List).take(10).toList()}');
    }).catchError((error) {
      debugPrint('Error loading anomaly model: $error');
    });
  }

  @override
  void initState() {
    super.initState();
    loadAnomalyInterpreter();
  }

  @override
  Widget build(BuildContext context) {
    final stream = nextDataStream();

    DateTime? startDate;
    DateTime? endDate;
    int? selectedValue;

    void clipVoltages() {
      if (_voltages.length > 187) {
        _clippedVoltages = _voltages.take(187).toList();
      } else {
        _clippedVoltages = _voltages;
      }

      while (_clippedVoltages.length < 187) {
        _clippedVoltages.add(0.0);
      }
    }

    Future<void> predictAnomaly() async {
      clipVoltages();
      if (_clippedVoltages.length != 187) {
        debugPrint('Clipped Voltages does not contain exactly 187 values!');
        return;
      }

      List<List<double>> formattedVoltages = [_clippedVoltages];

      try {
        List<List<double>> outputBuffer =
            List.generate(1, (_) => List.filled(187, 0.0));

        _anomalyInterpreter.run(formattedVoltages, outputBuffer);

        final outputVector = outputBuffer[0];
        debugPrint('Raw Output Vector: $outputVector');

        anomaly = outputVector.first > 0 ? 1 : 0;
        debugPrint("${outputVector.first}");
        debugPrint('Predicted Anomaly: $anomaly');
      } catch (e) {
        debugPrint('Error during inference: $e');
      }
    }

    void readVoltages() {
      debugPrint('selected data point: $_selectedDataPoint');

      if (_selectedDataPoint == null) {
        debugPrint('read voltages debug: return null');
        _voltages = [];
      } else {
        setState(() {
          _status = "Waiting";
        });

        debugPrint('read voltages: ${_selectedDataPoint!.value.toJson()}');
        final rawList = _selectedDataPoint!.value.toJson()['voltageValues'];

        if (rawList is List) {
          try {
            final lst = rawList.map((e) {
              if (e is Map<String, dynamic>) {
                return ElectrocardiogramVoltageValue.fromJson(e);
              } else {
                throw Exception("Invalid voltageValues format");
              }
            }).toList();

            var times = Iterable<int>.generate(lst.length).toList();

            _voltages = lst.map((e) {
              // debugPrint(
              //     'read voltages debug: return first ${e.voltage as double}');
              return 1000 * (e.voltage as double);
            }).toList();

            _data = times.map((t) {
              // debugPrint('read voltages debug: return second ${t.toDouble()}');
              return ECGData(time: t.toDouble(), voltage: _voltages[t]);
            }).toList();

            _tid = 0;
            debugPrint(
                'Number voltages: ${_data.length}. First: ${_data.first.voltage}');

            setState(() {
              _status = 'Prediction';
            });
          } catch (e) {
            debugPrint("Error processing voltages: $e");
            setState(() {
              _status = 'Error';
            });
          }
        }
      }
    }

    void changedSelectedDataPoint(HealthDataPoint? selectedDataPoint) {
      setState(() {
        _selectedDataPoint = selectedDataPoint;
        _status = 'Reading voltages';
        readVoltages();
      });
    }

    void readHealthData() async {
      try {
        final List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
          types: _types,
          startTime: start,
          endTime: now,
        );

        debugPrint('Value type: ${data.first.value.runtimeType}');
        debugPrint('Value content: ${data.first.value}');

        setState(
          () {
            _healthData = data;
            if (data.isNotEmpty) {
              debugPrint('ECG info: ${data.first.value.toString()}');
              changedSelectedDataPoint(data.first);
              _selectedDataPoint = data.first;
            } else {
              _selectedDataPoint = null;
              debugPrint('Health data is empty');
            }
          },
        );
      } catch (error) {
        _voltages = [];
        debugPrint('Exception in getHealthDataFromTypes: $error');
      }
    }

    void updateDateRange(int value) {
      now = DateTime.now();
      switch (value) {
        case 0:
          start = now.subtract(const Duration(days: 1));
          _ecgDataTimeRange = "Today";
          break;
        case 1:
          start = now.subtract(const Duration(days: 7));
          _ecgDataTimeRange = "1 Week";
          break;
        case 2:
          start = DateTime(now.year, now.month - 1, now.day);
          _ecgDataTimeRange = "1 Month";
          break;
        case 3:
          start = DateTime(now.year, now.month - 3, now.day);
          _ecgDataTimeRange = "3 Month";
          break;
        default:
          start = now;
      }

      setState(() {
        selectedValue = value;
        startDate = start;
        endDate = now;
      });

      debugPrint('Selected range: startDate = $startDate, endDate = $endDate');
      readHealthData();
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF202020), Color(0xFF202020)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const LoggedInNavbar(),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, user!',
                                style: heroHeaderTextStyle,
                              ),
                              Text(
                                'We’re excited to have you on board! Please choose a way to sign up or log in',
                                style: heroCaptionTextStyle,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0x336C6C6C),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ECG STATUS',
                                      style: heroHeaderTextStyle,
                                    ),
                                    const Icon(
                                      Icons.info,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                DropdownMenu(
                                  width: double.infinity,
                                  hintText: 'Choose time range',
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  dropdownMenuEntries: const [
                                    DropdownMenuEntry(
                                      value: 0,
                                      label: 'Today',
                                    ),
                                    DropdownMenuEntry(
                                      value: 1,
                                      label: '1 Week',
                                    ),
                                    DropdownMenuEntry(
                                      value: 2,
                                      label: '1 month',
                                    ),
                                    DropdownMenuEntry(
                                      value: 3,
                                      label: '3 Month',
                                    ),
                                  ],
                                  initialSelection: selectedValue,
                                  onSelected: (value) {
                                    if (value != null) {
                                      updateDateRange(value);
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.width * 0.55,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 5,
                                    ),
                                    child: RealTimeGraph(
                                      updateDelay:
                                          const Duration(milliseconds: 4),
                                      stream: stream.map((value) =>
                                          double.parse((value * 250)
                                              .toStringAsFixed(0))),
                                      supportNegativeValuesDisplay: true,
                                      displayYAxisValues: false,
                                      displayYAxisLines: false,
                                      pointsSpacing: 1,
                                      graphStroke: 3,
                                      axisStroke: 1,
                                      xAxisColor: Colors.white,
                                      graphColor: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Check Your Health',
                                style: heroHeaderTextStyle,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                'Use currently open ECG report to predict your health.',
                                style: heroCaptionTextStyle,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0x336C6C6C),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomTextButton(
                                  text: 'Predict Pregnancy',
                                  onPressed: () {
                                    if (_voltages.isEmpty || _status == "") {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            const CustomAlertDialog(
                                          title: "Warning",
                                          message:
                                              "Choose a time range first before continuing with the prediction.",
                                        ),
                                      );
                                    } else if (_status == "Waiting") {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            const CustomAlertDialog(
                                          title: "Warning",
                                          message: "Wait for the ecg to load.",
                                        ),
                                      );
                                    } else {
                                      loadAnomalyInterpreter();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PregnancyGenderPredictionPage(
                                            isNotHome: true,
                                            ecgDataTimeRange: _ecgDataTimeRange,
                                                selectedDataPoint: _selectedDataPoint!,
                                                voltages: _voltages,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomTextButton(
                                  text: 'Predict Heart Attack',
                                  onPressed: () async {
                                    if (_voltages.isEmpty || _status == "") {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            const CustomAlertDialog(
                                          title: "Warning",
                                          message:
                                              "Choose a time range first before continuing with the prediction.",
                                        ),
                                      );
                                    } else if (_status == "Waiting") {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            const CustomAlertDialog(
                                          title: "Warning",
                                          message: "Wait for the ecg to load.",
                                        ),
                                      );
                                    } else {
                                      await predictAnomaly();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HeartAttackPredictionForm(
                                            anomaly: anomaly,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
