import 'package:ecg/page/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:ecg/provider/decoration.dart';
import 'package:http/http.dart' as http;
import 'package:serious_python/serious_python.dart';

void main() {
  // startPython();
  runApp(const MyApp());
}

void startPython() async {
  SeriousPython.run("app/app.zip", environmentVariables: {"a": "1", "b": "2"});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ECG Analysis',
        theme: appThemeData,
        home: const MyHomePage(title: 'ECG Analysis'),
      );
  }
}

