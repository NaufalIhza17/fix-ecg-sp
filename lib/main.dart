import 'package:ecg/page/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:ecg/provider/decoration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ECG Analysis',
      theme: appThemeData,
      home: const LoginPage(),
    );
  }
}
