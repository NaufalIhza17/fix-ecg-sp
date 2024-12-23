import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecg/components/text_button.dart';
import 'package:ecg/components/input.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import './login_with_number.dart';
import '../health_authorization.dart';
import '../../components/alert_dialog.dart';

class LoginWithPasswordPage extends StatefulWidget {
  const LoginWithPasswordPage({
    super.key,
    this.email = '',
    this.phoneNumber = '',
  });

  final String email;
  final String phoneNumber;

  @override
  _LoginWithPasswordState createState() => _LoginWithPasswordState();
}

class _LoginWithPasswordState extends State<LoginWithPasswordPage> {
  bool _isHovered = false;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF202020), Color(0xFF171717)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  _returnButton(context),
                  const SizedBox(
                    height: 60,
                  ),
                  _content(context),
                ],
              ),
              _authenticationBox(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _returnButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHovered = false;
                });
              },
              child: Text(
                "Back",
                style: TextStyle(
                  fontSize: 20,
                  color: _isHovered ? Colors.white : const Color(0xFF939393),
                  height: 1.0,
                  decoration: _isHovered
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Password",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              height: 1.0,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "We’re excited to have you on board!\nInsert your ",
                  style: TextStyle(
                    color: Color(0xFF939393),
                    fontSize: 14,
                    height: 1.0,
                  ),
                ),
                TextSpan(
                  text: "password",
                  style: TextStyle(
                    color: Color(0xFFC6FF99),
                    fontSize: 14,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 26,
          ),
          CustomInput(
            controller: _passwordController,
            type: 'password',
            hintText: "Insert your password",
            errorMessage: "*wrong input",
            onChanged: (value) {},
            onPressed: () async {
              if (await sendDataToApi(
                  email: widget.email == '' ? null : widget.email,
                  phoneNumber:
                      widget.phoneNumber == '' ? null : widget.phoneNumber,
                  password: _passwordController.text)) {
                context.read<AuthProvider>().login();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HealthAuthorizationPage(),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const CustomAlertDialog(
                      title: "Failed to Login",
                      message: "Try again.",
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _authenticationBox(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
          color: const Color(0x1A6C6C6C),
          borderRadius: BorderRadius.circular(40),
        ),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Other Option",
                  style:
                      TextStyle(fontSize: 20, color: Colors.white, height: 1.0),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "You can choose other way to sign up or log in",
                  style: TextStyle(
                    color: Color(0xFF939393),
                    fontSize: 14,
                    height: 1.0,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                CustomTextButton(
                  text: "Continue with phone",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginWithNumberPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> sendDataToApi(
      {String? email, String? phoneNumber, required String password}) async {
    const String apiUrl = "http://127.0.0.1:8000/login";

    try {
      final Map<String, dynamic> body = {
        "email": email,
        "phone_number": phoneNumber,
        "password": password,
      };

      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        debugPrint("Response data: $responseData");
        if (responseData['status'] == "success") {
          debugPrint("Login successful!");
          return true;
        } else {
          debugPrint("Error: ${responseData['error']}");
          return false;
        }
      } else {
        debugPrint(
            "Error: ${response.statusCode} ${response.reasonPhrase} ${jsonDecode(response.body)['error']}");
        return false;
      }
    } catch (e) {
      debugPrint("Exception occurred: $e");
      return false;
    }
  }
}
