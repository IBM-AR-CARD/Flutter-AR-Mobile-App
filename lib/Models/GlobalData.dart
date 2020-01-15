import 'package:flutter_app/Models/UserData.dart';
class GlobalData {
  static final GlobalData globalData = GlobalData._internal();
  UserData _userData;
  factory GlobalData() {
    return globalData;
  }

  UserData get userData => _userData;

  set userData(UserData value) {
    _userData = value;
  }

  GlobalData._internal();
}