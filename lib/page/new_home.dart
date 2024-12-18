import 'dart:async';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:ecg/model/ecg_data.dart';
import 'package:ecg/model/ecg_report.dart';
import 'package:ecg/page/account_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:real_time_chart/real_time_chart.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io' show Platform;
import '../common.dart';
import '../components/logged_in_navbar.dart';
import '../components/text_button.dart';
import '../model/model.dart';
import '../model/model_output.dart';
import '../provider/blob_config.dart';
import '../provider/client.dart';
import '../provider/decoration.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:sqflite/sqflite.dart';
import '../provider/label_provider.dart';

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
                  LoggedInNavbar(),
                  Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AccountSettings(),
                                ),
                            );
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 5.0,
                                horizontal: 10.0,
                              ),
                            child: Row(
                              children: [
                                Text('Settings'),
                                Icon(Icons.settings),
                              ],
                            ),
                          )
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewHome(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            child: Row(
                              children: [
                                Text('Logout'),
                                Icon(Icons.logout),
                              ],
                            ),
                          )
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      const Text('Hello, user!'),
                      const Text('Check your health parameters below'),
                    ],
                  ),
                  Container(
                    width: 200,
                    height: 400,
                    decoration: const BoxDecoration(color: Color(0xFF6C6C6C)),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            const Text('ECG STATUS'),
                            Icon(
                              Icons.info,
                              color: Colors.white,
                            )
                          ],
                        ),
                        DropdownMenu(dropdownMenuEntries: [
                          DropdownMenuEntry(value: 0, label: '1 week'),
                          DropdownMenuEntry(value: 1, label: '1 month'),
                          DropdownMenuEntry(value: 2, label: '3 month'),
                          DropdownMenuEntry(value: 3, label: 'Custom range'),
                        ]),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(color: Colors.white),
                        )
                        // Graph
                        // Legend
                      ],
                    ),
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


