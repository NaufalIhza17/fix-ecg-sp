import 'package:ecg/model/heart_attack_data.dart';
import 'package:ecg/page/heart_attack_prediction_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import '../components/logged_in_navbar.dart';

class HeartAttackPredictionForm extends StatefulWidget {
  const HeartAttackPredictionForm({
    super.key,
    required this.anomaly,
  });

  final int anomaly;

  @override
  State<HeartAttackPredictionForm> createState() =>
      _HeartAttackPredictionFormPageState();
}

class _HeartAttackPredictionFormPageState
    extends State<HeartAttackPredictionForm> {
  // COMMON COMPONENTS
  TextStyle headerTextStyle = const TextStyle(
    color: Colors.black,
    //fontSize: 16,
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

  @override
  void initState() {
    super.initState();
    debugPrint("anomaly: ${widget.anomaly}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: const SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  LoggedInNavbar(
                    isNotHome: true,
                  ),
                  Column(
                    children: [
                      Text(
                        'Heart Attack Prediction',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        'Please answer questions below before proceeding.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  HeartAttackInfoForm()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum Sex {
  male(0),
  female(1);
  final int value;
  const Sex(this.value);
}

enum Smoking {
  no(0),
  yes(1);
  final int value;
  const Smoking(this.value);
}

// enum ChestPainLevel { no, mild, severe, worst }

const ChestPainLevel = [' No pain ', ' Mild Pain ', ' Severe Pain ', ' Worst Pain '];

class HeartAttackInfoForm extends StatefulWidget {
  const HeartAttackInfoForm({
    super.key,
  });

  @override
  State<HeartAttackInfoForm> createState() => _HeartAttackInfoFormState();
}

class _HeartAttackInfoFormState extends State<HeartAttackInfoForm> {
  final _formKey = GlobalKey<FormState>();
  Sex? _sex = Sex.male;
  Smoking? _smoking = Smoking.no;
  // ChestPainLevel? _chestPainLevel = ChestPainLevel.no;
  double _chestPainLevel = 0;
  final bool _anomaly = true;
  final _ageController = TextEditingController();
  double _age = 0;

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    TextStyle inputLabelTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.normal,
      height: 1.0,
    );

    TextStyle inputTextTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    );

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Sex',
                    style: inputLabelTextStyle,
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0x336C6C6C),
                  borderRadius: BorderRadius.circular(8.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: [
                          Radio<Sex>(
                            value: Sex.male,
                            groupValue: _sex,
                            onChanged: (Sex? value) {
                              setState(() {
                                _sex = value;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _sex = Sex.male;
                              });
                            },
                            child: Text(
                              'Male',
                              style: inputTextTextStyle,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<Sex>(
                            value: Sex.female,
                            groupValue: _sex,
                            onChanged: (Sex? value) {
                              setState(() {
                                _sex = value;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _sex = Sex.female;
                              });
                            },
                            child: Text(
                              'Female',
                              style: inputTextTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Age',
                    style: inputLabelTextStyle,
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0x336C6C6C),
                  border: OutlineInputBorder(),
                ),
                style: inputTextTextStyle,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                controller: _ageController,
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Do you smoke?',
                    style: inputLabelTextStyle,
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0x336C6C6C),
                    borderRadius: BorderRadius.circular(8.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: [
                          Radio<Smoking>(
                            value: Smoking.no,
                            groupValue: _smoking,
                            onChanged: (Smoking? value) {
                              setState(() {
                                _smoking = value;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _smoking = Smoking.no;
                              });
                            },
                            child: Text(
                              'No',
                              style: inputTextTextStyle,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<Smoking>(
                            value: Smoking.yes,
                            groupValue: _smoking,
                            onChanged: (Smoking? value) {
                              setState(() {
                                _smoking = value;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _smoking = Smoking.yes;
                              });
                            },
                            child: Text(
                              'Yes',
                              style: inputTextTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Do you have any chest pain?',
                    style: inputLabelTextStyle,
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0x336C6C6C),
                    borderRadius: BorderRadius.circular(8.0)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'None',
                      style: inputTextTextStyle,
                    ),
                    Slider(
                      value: _chestPainLevel,
                      max: 3,
                      divisions: 3,
                      label: ChestPainLevel[_chestPainLevel.round()],
                      onChanged: (double value) {
                        setState(() {
                          _chestPainLevel = value;
                        });
                      },
                    ),
                    Text(
                      'Worst',
                      style: inputTextTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Column(
            children: [
              Text(
                '* Prediction from this app is NOT a medical diagnosis. Please seek a medical professional to get proper diagnosis and treatment.',
                style: inputTextTextStyle,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                    _age = double.parse(_ageController.text);
                    // http get with the datas
                    final heartAttackData = HeartAttackData(
                        sex: _sex?.value == 0 ? false : true,
                        age: _age.round(),
                        chest_pain: _chestPainLevel.round(),
                        smoking: _smoking?.value == 0 ? false : true,
                        abnormality: true, // TODO
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        HeartAttackPredictionResult(heartAttackData: heartAttackData,),
                      ),
                    );
                  }
                },
                child: const Text('Get Prediction'),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
