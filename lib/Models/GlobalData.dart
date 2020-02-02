import 'package:flutter_app/Models/UserData.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
class GlobalData {
  static final GlobalData globalData = GlobalData._internal();
  bool _hasData = false;

  bool get hasData => _hasData;

  set hasData(bool value) {
    _hasData = value;
  }
  String _token;

  String get token => _token;

  set token(String value) {
    _token = value;
  }

  UserData _userData;
  factory GlobalData() {
    return globalData;
  }
  UnityWidgetController _unityWidgetController;

  UnityWidgetController get unityWidgetController => _unityWidgetController;
  resumeController(){
    if(_unityWidgetController != null){
      _unityWidgetController.resume();
    }
  }
  set unityWidgetController(UnityWidgetController value) {
    _unityWidgetController = value;
  }
  UserData _scanData;
  bool _hasLogin = false;

  bool get hasLogin => _hasLogin;

  set hasLogin(bool value) {
    _hasLogin = value;
  }
  clearData(){
    _hasData = false;
    _hasLogin = false;
    userData = null;
    scanData = null;
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