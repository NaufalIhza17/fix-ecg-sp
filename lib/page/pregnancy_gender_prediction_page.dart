import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../components/logged_in_navbar.dart';
import '../model/model.dart';
import '../model/model_output.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

import '../provider/blob_config.dart';
import '../provider/client.dart';

class PregnancyGenderPredictionPage extends StatefulWidget {
  const PregnancyGenderPredictionPage({
    super.key,
    this.isNotHome = false,
    required this.ecgDataTimeRange,
    required this.voltages,
    required this.selectedDataPoint,
  });

  final bool isNotHome;
  final String ecgDataTimeRange;
  final List<double> voltages;
  final HealthDataPoint selectedDataPoint;

  @override
  State<PregnancyGenderPredictionPage> createState() =>
      _PregnancyGenderPredictionPagePageState();
}

class _PregnancyGenderPredictionPagePageState
    extends State<PregnancyGenderPredictionPage> {
  Model? _selectedModel;
  int _averageTime = -1;
  List<ModelOutput> _genderOutputs = [];
  List<ModelOutput> _pregnancyOutputs = [];
  List<Model> _models = [];
  Stopwatch timer = Stopwatch();
  String _status = '';
  final int _numberOfTries = 1;

  late Interpreter _genderInterpreter;
  late Tensor _genderInputTensor;
  late Tensor _genderOutputTensor;
  late Interpreter _pregnancyInterpreter;
  late Tensor _pregnancyInputTensor;
  late Tensor _pregnancyOutputTensor;
  late UploadClient? client;

  void loadAllModel() {
    var model = _models[0];
    _selectedModel = model;
    tfl.Interpreter.fromAsset('assets/${model.fileName}.tflite').then((value) {
      _genderInterpreter = value;
      _genderInputTensor = _genderInterpreter.getInputTensors().first;
      _genderOutputTensor = _genderInterpreter.getOutputTensors().first;
    });
    model = _models[1];
    tfl.Interpreter.fromAsset('assets/${model.fileName}.tflite').then((value) {
      _pregnancyInterpreter = value;
      _pregnancyInputTensor = _pregnancyInterpreter.getInputTensors().first;
      _pregnancyOutputTensor = _pregnancyInterpreter.getOutputTensors().first;
    });
  }

  @override
  void initState() {
    super.initState();
    List<String> genderLabels = ['Female', 'Male'];
    List<String> pregnancyLabels = ['Non Pregnancy', 'Pregnancy'];
    _models = [
      Model(
          id: 0,
          fileName: 'resnet18_gender2',
          name: 'Resnet18',
          task: 'Gender',
          mean: -0.02404451,
          std: 0.6902185,
          threshold: 0.5,
          labels: genderLabels),
      Model(
          id: 1,
          fileName: 'resnet18_pregnant1',
          name: 'Resnet18',
          task: 'Pregnancy',
          mean: -0.0251138,
          std: 0.7312898,
          threshold: 0.80,
          labels: pregnancyLabels),
      const Model(
        id: 2,
        fileName: 'resnet18',
        name: 'Resnet18',
        task: 'Gender-Pregnancy',
        mean: 0.0,
        std: 1.0,
        threshold: 0.0,
        labels: [],
      ),
    ];
    loadAllModel();
    uploadSignal(widget.selectedDataPoint.dateFrom, widget.voltages);
  }

  @override
  Widget build(BuildContext context) {
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
                    LoggedInNavbar(
                      isNotHome: widget.isNotHome,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chosen ECG Data',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 20,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        color: Color(0x3F6C6C6C),
                      ),
                      child: Text(
                        widget.ecgDataTimeRange,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Our Prediction',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Gender Prediction',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "${_getGenderLabel()} - $_status",
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Color(0xFFD3D331),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Pregnancy Prediction',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "${_getPregnancyLabel()} - $_status",
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Color(0xFFD3D331),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
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

  String _getGenderLabel() {
    int genderCount = 0;
    _averageTime = 0;

    for (int i = 0; i < _genderOutputs.length; ++i) {
      if (_genderOutputs[i].time > -1) {
        genderCount++;
        _averageTime += _genderOutputs[i].time;
      }
    }

    if (genderCount > 0) {
      _averageTime = _averageTime ~/ genderCount;
    } else {
      _averageTime = -1;
      return 'Failed (No prediction) by gender';
    }

    int g0 =
        _genderOutputs.where((e) => e.value < _selectedModel!.threshold).length;
    int g1 = _genderOutputs.length - g0;

    if (g0 > g1) {
      return '${_selectedModel!.labels[0]} ($g0/${_genderOutputs.length}) in $_averageTime ms';
    } else {
      return '${_selectedModel!.labels[1]} ($g1/${_genderOutputs.length}) in $_averageTime ms';
    }
  }

  String _getPregnancyLabel() {
    int pregnancyCount = 0;
    _averageTime = 0;

    for (int i = 0; i < _pregnancyOutputs.length; ++i) {
      if (_pregnancyOutputs[i].time > -1) {
        pregnancyCount++;
        _averageTime += _pregnancyOutputs[i].time;
      }
    }

    if (pregnancyCount > 0) {
      _averageTime = _averageTime ~/ pregnancyCount;
    } else {
      _averageTime = -1;
      return 'Failed (No prediction) by pregnancy';
    }

    int p0 = _pregnancyOutputs
        .where((e) => e.value < _selectedModel!.threshold)
        .length;
    int p1 = _pregnancyOutputs.length - p0;

    if (p0 > p1) {
      return '${_selectedModel!.labels[0]} ($p0/${_pregnancyOutputs.length}) in $_averageTime ms';
    } else {
      return '${_selectedModel!.labels[1]} ($p1/${_pregnancyOutputs.length}) in $_averageTime ms';
    }
  }

  List<double> normalizeInput(List<double> input, Model model) {
    return input.map((e) {
      return (e - model.mean) / model.std;
    }).toList();
  }

  void _resetModelOutputs() {
    _averageTime = -1;
    _genderOutputs = List<ModelOutput>.filled(
      _numberOfTries,
      const ModelOutput(value: -1, time: -1),
    );
    _pregnancyOutputs = List<ModelOutput>.filled(
      _numberOfTries,
      const ModelOutput(value: -1, time: -1),
    );
  }

  Future uploadSignal(DateTime startTime, List<double> data) async {
    try {
      client = UploadClient(
        signal: data,
        blobConfig: BlobConfig(
          blobUrl: "http://192.168.0.101:8000",
        ),
      );

      client!.uploadSignal(
        onComplete: (_) {
          setState(() {
            _resetModelOutputs();
            for (int i = 0; i < _numberOfTries; ++i) {
              getCWT(i);
            }
            _status = 'Get CWT';
          });
        },
        onTimeout: () {
          setState(() {
            _status = 'Connection failed';
          });
        },
      );
    } catch (e) {
      setState(() {
        _status = 'Connection failed err';
      });
      return;
    }
  }

  Future getCWT(int segmentId) async {
    debugPrint('Segment $segmentId: ');
    try {
      client!.getCWT(
        segmentId,
        onComplete: (value) {
          if (value.isNotEmpty) {
            var key = value.keys.first;
            var genderOutput = [
              [0.0]
            ];
            var pregnancyOutput = [
              [0.0]
            ];
            var id = _selectedModel!.id;
            timer.reset();
            timer.start();
            if (id == 0) {
              var cwt = normalizeInput(value[key]!, _models[0]);
              var input = cwt.reshape(_genderInputTensor.shape);
              _genderInterpreter.run(input, genderOutput);
            } else if (id == 1) {
              var cwt = normalizeInput(value[key]!, _models[1]);
              var input = cwt.reshape(_pregnancyInputTensor.shape);
              _pregnancyInterpreter.run(input, pregnancyOutput);
            } else if (id == 2) {
              var cwt1 = normalizeInput(value[key]!, _models[0]);
              var input1 = cwt1.reshape(_genderInputTensor.shape);
              var cwt2 = normalizeInput(value[key]!, _models[1]);
              var input2 = cwt2.reshape(_pregnancyInputTensor.shape);
              _genderInterpreter.run(input1, genderOutput);
              _pregnancyInterpreter.run(input2, pregnancyOutput);
            }
            timer.stop();

            setState(() {
              if (id == 0) {
                _genderOutputs[key] = ModelOutput(
                    value: genderOutput.first.first,
                    time: timer.elapsedMilliseconds);
                debugPrint('Gender Output: ${genderOutput.first.first}');
              } else if (id == 1) {
                _pregnancyOutputs[key] = ModelOutput(
                    value: pregnancyOutput.first.first,
                    time: timer.elapsedMilliseconds);
                debugPrint('Pregnancy Output: ${genderOutput.first.first}');
              } else if (id == 2) {
                _genderOutputs[key] = ModelOutput(
                    value: genderOutput.first.first,
                    time: timer.elapsedMilliseconds);
                _pregnancyOutputs[key] = ModelOutput(
                    value: pregnancyOutput.first.first,
                    time: timer.elapsedMilliseconds);
                debugPrint('Gender Output: ${genderOutput.first.first}');
                debugPrint('Pregnancy Output: ${pregnancyOutput.first.first}');
              }
              debugPrint('--------------------------------------------');
            });
          }
        },
        onTimeout: () {
          setState(() {
            _status = 'Predicting failed';
          });
        },
      );
    } catch (e) {
      setState(() {
        _status = e.toString();
      });

      return;
    }
  }
}
