import 'dart:async';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:ecg/model/ecg_data.dart';
import 'package:ecg/model/ecg_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:real_time_chart/real_time_chart.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io' show Platform;
import '../common.dart';
import '../model/model.dart';
import '../model/model_output.dart';
import '../provider/blob_config.dart';
import '../provider/client.dart';
import '../provider/decoration.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:sqflite/sqflite.dart';
import '../provider/label_provider.dart';

class NewHome extends StatefulWidget {
  const NewHome({super.key, required this.title});
  final String title;

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
        appBar: AppBar(
          backgroundColor: appThemeData.colorScheme.inversePrimary,
          title: Text(widget.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 22)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Common.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: const Text(
                    'Hello, user!'
                  ),
                ),
                Container(
                  child: const Text(
                      'Check your health parameters below'
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      child: const Text(
                          'Hello, user!'
                      ),
                    ),
                    DropdownMenu(
                      dropdownMenuEntries: [
                        DropdownMenuEntry(value: 0, label: 'Profile'),
                        DropdownMenuEntry(value: 1, label: 'Log out'),
                      ]
                    ),
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}