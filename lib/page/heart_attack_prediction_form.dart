import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import '../components/logged_in_navbar.dart';

class HeartAttackPredictionForm extends StatefulWidget {
  const HeartAttackPredictionForm({
    super.key,
  });

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
                  AccountInfoForm()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AccountInfoForm extends StatelessWidget {
  const AccountInfoForm({
    super.key,
  });

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

    return Column(
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
            TextFormField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0x336C6C6C),
                border: OutlineInputBorder(),
              ),
              style: inputTextTextStyle,
            ),
          ],
        ),
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
            TextFormField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0x336C6C6C),
                border: OutlineInputBorder(),
              ),
              style: inputTextTextStyle,
            ),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 24.0,
                bottom: 12.0
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Do you smoke?',
                    style: inputLabelTextStyle,
                  ),
                ],
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0x336C6C6C),
                border: OutlineInputBorder(),
              ),
              style: inputTextTextStyle,
            ),
          ],
        ),
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
            TextFormField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0x336C6C6C),
                border: OutlineInputBorder(),
              ),
              style: inputTextTextStyle,
              obscureText: true,
              obscuringCharacter: '*',
            ),
          ],
        ),
        Column(
          children: [
            Text(
                '* Prediction from this app is NOT a medical diagnosis. Please seek a medical professional to get proper diagnosis and treatment.',
              style: inputTextTextStyle,
            ),
            ElevatedButton(
              onPressed: null,
              child: Text('Check Prediction'),
            )
          ],
        )
      ],
    );
  }
}
