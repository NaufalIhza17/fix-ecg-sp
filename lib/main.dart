import 'package:ecg/page/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:ecg/provider/decoration.dart';
import 'package:ecg/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:ecg/page/health_authorization.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
    ],
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ECG Analysis',
      theme: appThemeData,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return authProvider.isAuthorized
              ? const HealthAuthorizationPage()
              : const LoginPage();
        },
      ),
    );
  }
}
