import 'package:ecg/model/heart_attack_data.dart';
import 'package:ecg/provider/heart_attack_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import '../components/logged_in_navbar.dart';

enum HeartAttackResult { likely, noRisk, failed }

class HeartAttackPredictionResult extends StatefulWidget {
  const HeartAttackPredictionResult({
    super.key,
    required this.heartAttackData,
  });

  final HeartAttackData heartAttackData;

  @override
  State<HeartAttackPredictionResult> createState() =>
      _HeartAttackPredictionResultPageState();
}

class _HeartAttackPredictionResultPageState
    extends State<HeartAttackPredictionResult> {
  bool _result = true;
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
                  const LoggedInNavbar(
                    isNotHome: true,
                  ),
                  const Text(
                    'Heart Attack Prediction Result',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      height: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  ChangeNotifierProvider.value(
                      value: HeartAttackProvider(),
                      child: HeartAttackResultPoster(
                          heartAttackData: widget.heartAttackData))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum Sex { male, female }

enum Smoking { no, yes }

enum ChestPainLevel { no, mild, severe, worst }

class HeartAttackResultPoster extends StatefulWidget {
  const HeartAttackResultPoster({
    super.key,
    required this.heartAttackData,
  });

  final HeartAttackData heartAttackData;

  @override
  State<HeartAttackResultPoster> createState() =>
      _HeartAttackResultPosterState();
}

class _HeartAttackResultPosterState extends State<HeartAttackResultPoster> {
  final _formKey = GlobalKey<FormState>();
  bool _result = true;

  @override
  Widget build(BuildContext context) {
    final TextStyle inputLabelTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.normal,
      height: 1.0,
    );

    final TextStyle inputTextTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    );

    HeartAttackData _heartAttackData = widget.heartAttackData;

    return Column(
      children: [
        FutureBuilder(
            future: Provider.of<HeartAttackProvider>(context, listen: false)
                .getHeartAttackPrediction(_heartAttackData),
            builder: (context, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<HeartAttackProvider>(
                    child: Center(
                      //TODO
                      heightFactor: MediaQuery.of(context).size.height * 0.03,
                      child: Text(
                        'Prediction failed.',
                        style: inputTextTextStyle,
                      ),
                    ),
                    builder: (context, heartAttackProvider, child) =>
                        heartAttackProvider.heartAttackDataPrediction.isEmpty
                            ? child as Widget
                            : Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(child: () {
                                  if (heartAttackProvider
                                          .heartAttackDataPrediction[0] ==
                                      true) {
                                    return HeartAttackHero(result: true,);
                                  }
                                  return HeartAttackHero(result: false,);
                                }()),
                              ),
                  )),

      ],
    );
  }
}

class HeartAttackHero extends StatelessWidget {
  HeartAttackHero({
    super.key,
    required this.result,
  });

  final result;

  final TextStyle inputLabelTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.normal,
    height: 1.0,
  );

  final TextStyle inputTextTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  @override
  Widget build(BuildContext context) {
    IconData heartIcon = result ? Icons.heart_broken : Icons.favorite;
    String label = result ? 'At risk' : 'No risk';
    String _description = '';
    if (result) {
      _description =
          'Based on your health data, you are more likely than average person to get a heart attack.';
    } else {
      _description =
          'No risk detected from your health parameters. Please keep a healthy lifestyle to keep your risk low.';
    }
    return Column(
      children: [
        Icon(
          heartIcon,
          size: 128.0,
          color: Colors.white,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: inputLabelTextStyle,
            ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Text(
          _description,
          style: inputTextTextStyle,
        ),
      ],
    );
  }
}
