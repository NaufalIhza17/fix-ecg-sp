import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthorized = false;

  bool get isAuthorized => _isAuthorized;

  void login() {
    _isAuthorized = true;
    debugPrint("authorization: $_isAuthorized");
    notifyListeners();
  }

  void logout() {
    _isAuthorized = false;
    debugPrint("authorization: $_isAuthorized");
    notifyListeners();
  }
}
