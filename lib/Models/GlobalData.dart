import 'package:flutter_app/Models/UserData.dart';
class GlobalData {
  static final GlobalData globalData = GlobalData._internal();
  bool _hasData = false;

  bool get hasData => _hasData;

  set hasData(bool value) {
    _hasData = value;
  }

  UserData _userData;
  factory GlobalData() {
    return globalData;
  }
  UserData _scanData;
  bool _hasLogin = false;

  bool get hasLogin => _hasLogin;

  set hasLogin(bool value) {
    _hasLogin = value;
  }

  UserData get scanData => _scanData;

  set scanData(UserData value) {
    _scanData = value;
  }

  UserData get userData => _userData;

  set userData(UserData value) {
    _userData = value;
  }

  GlobalData._internal();
}