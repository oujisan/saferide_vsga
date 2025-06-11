import 'package:flutter/material.dart';
import 'package:saferide/core/db_helper.dart';

class AuthProvider extends ChangeNotifier {
  String _username = '';
  String _password = '';

  String get username => _username;
  String get password => _password;

  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  Future<bool> login() async {
    final users = await DbHelper().getData('users');
    for (var user in users) {
      if (user['username'] == _username && user['password'] == _password) {
        return true;
      }
    }
    return false;
  }

}
