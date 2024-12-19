import 'package:ecg/page/account_settings.dart';
import 'package:ecg/page/heart_attack_prediction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import '../components/logged_in_navbar.dart';

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

  TextStyle heroHeaderTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.normal,
    // height: 1.0,
  );

  TextStyle heroCaptionTextStyle = const TextStyle(
    color: Colors.grey,
    fontSize: 16,
    // height: 1.0,
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
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const LoggedInNavbar(),
                  Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, user!',
                            style: heroHeaderTextStyle,
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            'We’re excited to have you on board! Please choose a way to sign up or log in',
                            style: heroCaptionTextStyle,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                          color: Color(0x336C6C6C),
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
                                  Icon(
                                    Icons.info,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              DropdownMenu(dropdownMenuEntries: [
                                DropdownMenuEntry(value: 0, label: '1 week'),
                                DropdownMenuEntry(value: 1, label: '1 month'),
                                DropdownMenuEntry(value: 2, label: '3 month'),
                                DropdownMenuEntry(
                                    value: 3, label: 'Custom range'),
                              ]),
                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                height: 100,
                                width: 100,
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                              )
                              // Graph
                              // Legend
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 36,
                  ),
                  Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                          color: Color(0x336C6C6C),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const HeartAttackPredictionForm(),
                                    ),
                                  );
                                },
                                label: Text(
                                  'Heart Attack',
                                  style: heroHeaderTextStyle,
                                ),
                                icon: Icon(
                                  Icons.heart_broken,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFF000000),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Heart Attack',
                                        style: heroHeaderTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFF000000),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.pregnant_woman,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Text(
                                        'Pregnancy',
                                        style: heroHeaderTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Graph
                              // Legend
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
    );
  }
}
