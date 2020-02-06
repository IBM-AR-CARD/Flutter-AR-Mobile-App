import 'package:flutter_app/Models/UserData.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
class GlobalData {
  static final GlobalData globalData = GlobalData._internal();
  bool _hasData = false;

  bool get hasData => _hasData;

  set hasData(bool value) {
    _hasData = value;
  }
  String _token;

  String get token => _token;
  bool _wantLogin = false;

  bool get wantLogin => _wantLogin;

  set wantLogin(bool value) {
    _wantLogin = value;
  }

  set token(String value) {
    _token = value;
  }

  UserData _userData;
  factory GlobalData() {
    return globalData;
  }
  UnityWidgetController _unityWidgetController;

  UnityWidgetController get unityWidgetController => _unityWidgetController;
  QRViewController _qrViewController;


  QRViewController get qrViewController => _qrViewController;

  set qrViewController(QRViewController value) {
    _qrViewController = value;
  }

  resumeUnityController(){
    if(_qrViewController != null){
      _qrViewController.pauseCamera();
    }
    if(_unityWidgetController != null){
      _unityWidgetController.resume();
    }
  }
  resumeQRViewController() {
    if (_unityWidgetController != null) {
      _unityWidgetController.pause();
    }
    if (_qrViewController != null) {
      _qrViewController.resumeCamera();
    }
  }
  stopAllController() {
    if (_unityWidgetController != null) {
      _unityWidgetController.pause();
    }
    if (_qrViewController != null) {
      _qrViewController.pauseCamera();
    }
  }

    set unityWidgetController(UnityWidgetController value) {
      _unityWidgetController = value;
    }
    UserData _scanData;
    bool _hasLogin = false;
    String _id;

    String get id => _id;

    set id(String value) {
      _id = value;
    }

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