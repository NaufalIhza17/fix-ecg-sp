import 'package:ecg/components/otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecg/components/text_button.dart';
import '../my_home_page.dart';
import './login_with_email.dart';
import './login_with_number.dart';

class LoginWithOTPPage extends StatefulWidget {
  const LoginWithOTPPage({super.key, required this.fromEmail});

  final bool fromEmail;

  @override
  _LoginWithOTPState createState() => _LoginWithOTPState();
}

class _LoginWithOTPState extends State<LoginWithOTPPage> {
  bool _isHovered = false;

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
                  // Change color on hover
                  height: 1.0,
                  decoration: _isHovered
                      ? TextDecoration.underline
                      : TextDecoration.none, // Underline on hover
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
            "OTP",
            style: TextStyle(fontSize: 20, color: Colors.white, height: 1.0),
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
                      color: Color(0xFF939393), fontSize: 14, height: 1.0),
                ),
                TextSpan(
                  text: "OTP",
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
          CustomOTP(
            controllers: List.generate(4, (index) => TextEditingController()),
            errorMessage: '*please enter a valid OTP',
            onChanged: (value) {},
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyHomePage(title: 'FROM OTP'),
                ),
              );
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
                  text: "Continue with ${!widget.fromEmail ? "email" : "number"}",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => !widget.fromEmail
                            ? const LoginWithEmailPage()
                            : const LoginWithNumberPage(),
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
}
