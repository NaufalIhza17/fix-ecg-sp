import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecg/components/text_button.dart';
import 'package:health/health.dart';
import './new_home.dart';

class HealthAuthorizationPage extends StatefulWidget {
  const HealthAuthorizationPage({super.key});

  @override
  _HealthAuthorizationState createState() => _HealthAuthorizationState();
}

class _HealthAuthorizationState extends State<HealthAuthorizationPage> {
  final Health _health = Health();
  final List<HealthDataType> _types = [HealthDataType.ELECTROCARDIOGRAM];
  bool _isAuthorized = false;
  bool _isRequesting = false;

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
    _health.configure();
    _checkAuthorization();
  }

  Future<void> _checkAuthorization() async {
    final isAuthorized = await _health.requestAuthorization(_types);
    debugPrint('isAuthorized: $isAuthorized');
    setState(() {
      _isAuthorized = isAuthorized;
    });
  }

  Future<void> _requestAuthorization() async {
    setState(() {
      _isRequesting = true;
    });

    try {
      final isAuthorized = await _health.requestAuthorization(_types);

      if (!mounted) return;

      setState(() {
        _isAuthorized = isAuthorized;
        _isRequesting = false;
      });

      if (isAuthorized) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authorization denied. Please try again.'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error requesting authorization: $e');
      setState(() {
        _isRequesting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: _buildUI(context),
      ),
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


  Widget _content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Connect",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              height: 1.0,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            "Allow this application access your health data from your device.",
            style: TextStyle(
              color: Color(0xFF939393),
              fontSize: 14,
              height: 1.25,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _isRequesting
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFC6FF99)),
                  ),
                )
              : CustomTextButton(
                  bgColor: '0xFFC6FF99',
                  txtColor: '0xFF77A454',
                  text: _isAuthorized ? "Go to Home" : 'Allow',
                  onPressed: _isAuthorized
                      ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewHome(),
                            ),
                          )
                      : _requestAuthorization,
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
                  "Information",
                  style:
                      TextStyle(fontSize: 20, color: Colors.white, height: 1.0),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "If you can’t grant the permission on this page, you might need to do it manually by opening your phone's settings.",
                  style: TextStyle(
                    color: Color(0xFF939393),
                    fontSize: 14,
                    height: 1.25,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "You can follow this steps:\n",
                        style: TextStyle(
                          color: Color(0xFF939393),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "1. Go to ",
                        style: TextStyle(
                          color: Color(0xFF939393),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "Settings\n",
                        style: TextStyle(
                          color: Color(0xFF64A2FF),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "2. Scroll down and choose ",
                        style: TextStyle(
                          color: Color(0xFF939393),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "Apps\n",
                        style: TextStyle(
                          color: Color(0xFF64A2FF),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "3. Find ",
                        style: TextStyle(
                          color: Color(0xFF939393),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "Health\n",
                        style: TextStyle(
                          color: Color(0xFF64A2FF),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "4. Choose ",
                        style: TextStyle(
                          color: Color(0xFF939393),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "Data Access & Devices\n",
                        style: TextStyle(
                          color: Color(0xFF64A2FF),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "5. Pick ",
                        style: TextStyle(
                          color: Color(0xFF939393),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "ECG ",
                        style: TextStyle(
                          color: Color(0xFF64A2FF),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "application\n6. ",
                        style: TextStyle(
                          color: Color(0xFF939393),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "Turn on all ",
                        style: TextStyle(
                          color: Color(0xFF64A2FF),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "or ",
                        style: TextStyle(
                          color: Color(0xFF939393),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "tap the switch button",
                        style: TextStyle(
                          color: Color(0xFF64A2FF),
                          fontSize: 14,
                          height: 1.5,
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
    );
  }
}
