import 'dart:convert';

import 'package:ecg/model/heart_attack_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HeartAttackProvider with ChangeNotifier {
  List<bool> _heartAttackDataPrediction  = [];
  final url = 'http://192.168.106.166:8000/heart-attack-prediction';

  List<bool> get heartAttackDataPrediction {
    return [..._heartAttackDataPrediction];
  }

  Future<void> getHeartAttackPrediction(HeartAttackData data) async {
    try {
      Map<String, dynamic> request = {
        "sex": data.sex,
        "age": data.age,
        "chest_pain": data.chest_pain,
        "smoking": data.smoking,
        "abnormality": data.abnormality,
      };
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(
          Uri.parse(url), headers: headers, body: json.encode(request));
      Map<String, dynamic> responsePayload = json.decode(response.body);
      final heartAttackDataPrediction = responsePayload["prediction"];
      // debugPrint(heartAttackDataPrediction.toString());
      _heartAttackDataPrediction = [ heartAttackDataPrediction.toString().toLowerCase() != "false" ];
      debugPrint(_heartAttackDataPrediction[0].toString());
    } on Exception catch (e) {
      print(e);
    }
    notifyListeners();
  }
}