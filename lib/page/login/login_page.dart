import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecg/components/text_button.dart';
import '../my_home_page.dart';
import './login_with_number.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              _title(context),
              _authenticationBox(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
          ),
          Text(
            "ECG",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 64,
              height: 1.0,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 200,
            child: Text(
              "Guide you to living your best life",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 16,
                height: 1.25,
              ),
            ),
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
                  "Get Started",
                  style:
                      TextStyle(fontSize: 20, color: Colors.white, height: 1.0),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "We’re excited to have you on board! Please choose a way to sign up or log in",
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
                const SizedBox(
                  height: 10,
                ),
                CustomTextButton(
                  text: "Continue with email",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage(
                                title: 'From Login',
                              )),
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
