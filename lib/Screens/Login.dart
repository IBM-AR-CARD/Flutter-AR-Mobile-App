import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter_app/Models/GlobalData.dart';
import 'package:flutter_app/Models/SlideRoute.dart';
import 'package:flutter_app/Models/UserData.dart';
import 'package:flutter_app/Screens/ScanQR.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:vibration/vibration.dart';
import '../Models/Config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:flutter/scheduler.dart';
class Login extends StatefulWidget {
  @override
  State createState() => _Login();
}

class _Login extends State<Login> with TickerProviderStateMixin {
  double _width;
  double _height;
  bool isLogin = true;
  bool isRemembered = false;
  final jsonEncoder = JsonEncoder();
  final jsonDecoder = JsonDecoder();
  TextEditingController loginEMAIL = TextEditingController();
  TextEditingController loginPassword = TextEditingController();
  TextEditingController registerUserName = TextEditingController();
  TextEditingController registerPassword = TextEditingController();
  TextEditingController registerPasswordConfirm = TextEditingController();
  TextEditingController registerEmail = TextEditingController();
  Animation<Offset> offset1;
  Animation<Offset> offset2;
  Animation<Offset> expandOffset;
  AnimationController loginTextController;
  Animation<double> loginTextOffset;
  AnimationController registerTextController;
  Animation<double> registerTextOffset;
  AnimationController controller1;
  AnimationController controller2;
  AnimationController expandController;
  List<Widget> inputFields = List();
  FocusNode loginEMAILFocus = FocusNode();
  FocusNode loginPasswordFocus = FocusNode();
  FocusNode registerUserNameFocus = FocusNode();
  FocusNode registerPasswordFocus = FocusNode();
  FocusNode registerPasswordConfirmFocus = FocusNode();
  FocusNode registerEmailFocus = FocusNode();
  String loginText =  'Welcome back to IBM AR Card';
  String registerText = 'Register now to sync your scan history and\nfavourites, also creating your own AR card!';
  final ERROR_COLOR =  Colors.pink;
  final NORMAL_COLOR = Color.fromARGB(130, 31, 34, 52);
  bool loginValid = true;
  bool registerValid = true;
  bool hasExpand = true;
  toDefaultText(){
    registerValid  = true;
    loginValid =  true;
    loginText =  'Welcome back to IBM AR Card';
    registerText = 'Register now to sync your scan history and\nfavourites, also creating your own AR card!';
    setState(() {

    });
  }
  initAnimation() {
    controller1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    controller2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    loginTextController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(()=>setState((){}));
    registerTextController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(()=>setState((){}));
    offset1 = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
        .animate(
        new CurvedAnimation(parent: controller1, curve: Curves.easeInOut));
    offset2 = Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
        .animate(
        new CurvedAnimation(parent: controller2, curve: Curves.easeInOut));
    expandOffset = Tween<Offset>(begin: Offset(0.0, 1.5), end: Offset(0.0, 0.25))
        .animate(
        new CurvedAnimation(parent: expandController, curve: Curves.easeInOut));
    controller2.animateTo(1,
        duration: Duration(milliseconds: 50), curve: Curves.easeInOut);
  }
  math.Vector3 getTranslation(controller) {
    double progress = controller.value;
    double offset = sin(progress * pi * 90)*3;
    return math.Vector3(offset, 0.0, 0.0);
  }
  Widget getTextField(String name) {
    bool obscure = false;
    if(name.endsWith("PASSWORD")){
      obscure = true;
    }
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: Container(
            width: _width,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 219, 220, 230),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: TextFormField(
              obscureText: obscure,
              textInputAction: getTextInputAction(name),
              focusNode: getFocusNode(name),
              onFieldSubmitted: getOnSubmit(name),
              controller: getController(name),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: gethintText(name),
                contentPadding: EdgeInsets.all(20),
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: getPrefixIcon(name),
              ),
            )));
  }
  getOnSubmit(String name){
    switch (name) {
      case 'registerUSERNAME':
        return (value){
          FocusScope.of(context).requestFocus(registerEmailFocus);
        };
      case 'registerPASSWORD':
        return (value){
          FocusScope.of(context).requestFocus(registerPasswordConfirmFocus);
        };
      case 'registerE-MAIL':
        return (value){
          FocusScope.of(context).requestFocus(registerPasswordFocus);
        };
      case 'registerCONFIRM PASSWORD':
        return (value){
        };
      case 'loginEMAIL':
        return (value){
          FocusScope.of(context).requestFocus(loginPasswordFocus);
        };
      case 'loginPASSWORD':
        return (value){};
    }
    return (value){};
  }
  TextInputAction getTextInputAction(String name){
    switch (name) {
      case 'registerCONFIRM PASSWORD':
        return TextInputAction.done;
      case 'loginPASSWORD':
        return TextInputAction.done;
    }
    return TextInputAction.next;
  }
  String gethintText(String name) {
    switch (name) {
      case 'registerUSERNAME':
        return 'USERNAME';
      case 'registerPASSWORD':
        return 'PASSWORD';
      case 'registerE-MAIL':
        return 'E-MAIL';
      case 'registerCONFIRM PASSWORD':
        return 'CONFIRM PASSWORD';
      case 'loginEMAIL':
        return 'E-MAIL';
      case 'loginPASSWORD':
        return 'PASSWORD';
    }
  }

  FocusNode getFocusNode(String name) {
    switch (name) {
      case 'registerUSERNAME':
        return registerUserNameFocus;
      case 'registerPASSWORD':
        return registerPasswordFocus;
      case 'registerE-MAIL':
        return registerEmailFocus;
      case 'registerCONFIRM PASSWORD':
        return registerPasswordConfirmFocus;
      case 'loginEMAIL':
        return loginEMAILFocus;
      case 'loginPASSWORD':
        return loginPasswordFocus;
    }
  }
  TextEditingController getController(String name) {
      switch (name) {
        case 'registerUSERNAME':
          return registerUserName;
        case 'registerPASSWORD':
          return registerPassword;
        case 'registerE-MAIL':
          return registerEmail;
        case 'registerCONFIRM PASSWORD':
          return registerPasswordConfirm;
        case 'loginEMAIL':
          return loginEMAIL;
        case 'loginPASSWORD':
          return loginPassword;
      }
    }
  Icon getPrefixIcon(String name) {
      switch (name) {
        case 'loginEMAIL':
          return Icon(
            Icons.email,
            size: 30,
            color: Color.fromARGB(180, 41, 43, 66),
          );
        case 'loginPASSWORD':
          return Icon(
            Icons.lock,
            size: 30,
            color: Color.fromARGB(180, 41, 43, 66),
          );
        case 'registerCONFIRM PASSWORD':
          return Icon(
            Icons.lock,
            size: 30,
            color: Color.fromARGB(180, 41, 43, 66),
          );
        case 'registerE-MAIL':
          return Icon(
            Icons.email,
            size: 30,
            color: Color.fromARGB(180, 41, 43, 66),
          );
        case 'registerUSERNAME':
          return Icon(
            Icons.person,
            size: 30,
            color: Color.fromARGB(180, 41, 43, 66),
          );
        case 'registerPASSWORD':
          return Icon(
            Icons.lock,
            size: 30,
            color: Color.fromARGB(180, 41, 43, 66),
          );
      }
    }

    @override
  Widget build(BuildContext context) {
      _width = MediaQuery
          .of(context)
          .size
          .width;
      _height = MediaQuery
          .of(context)
          .size
          .height;
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 55, 51, 75),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child:Container(
                  width: _width,
                  height: _height,
                  child: Stack(
                    children: <Widget>[
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        height: hasExpand ? _height : _height*0.2 ,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [
                                  0.3,
                                  1
                                ],
                                colors: [
                                  Color.fromARGB(255, 69, 67, 89),
                                  Color.fromARGB(255, 55, 51, 75)
                                ])),
                        child: Center(
                          child: Image.asset(
                            'assets/images/launch_icon.png',
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                      SlideTransition(
                        position: expandOffset,
                        child:ClipRRect(
                            borderRadius: BorderRadius.only(topLeft:Radius.circular(20.0),topRight: Radius.circular(20.0)),
                        child:Container(
                          color: Colors.transparent,
                          height: _height*0.8,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: _height * 0.1,
                                child: Row(
                                  children: <Widget>[
                                    AnimatedContainer(
                                      width: _width * 0.5,
                                      height: _height * 0.1,
                                      duration: Duration(milliseconds: 500),
                                      color: isLogin
                                          ? Colors.white
                                          : Color.fromARGB(255, 219, 220, 230),
                                      child: FlatButton(
                                        onPressed: changeToLogin,
                                        child: Text(
                                          'LOGIN',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(255, 69, 67, 89)),
                                        ),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      width: _width * 0.5,
                                      height: _height * 0.1,
                                      duration: Duration(milliseconds: 500),
                                      color: !isLogin
                                          ? Colors.white
                                          : Color.fromARGB(255, 219, 220, 230),
                                      child: FlatButton(
                                        onPressed: changeToRegister,
                                        child: Text(
                                          'REGISTER',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(255, 69, 67, 89)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                child: Stack(children: [
                                  SlideTransition(
                                    position: offset1,
                                    child: getRegisterPage(),
                                  ),
                                  SlideTransition(
                                    position: offset2,
                                    child: getLoginPage(),
                                  ),
                                ]),
                              )
                            ],
                          ),
                        )
                      ),
                      )
                    ],
                  ),
                )
        )
      );
    }
  toDefaultLayout()async{
    hasExpand = true;
    setState(() {

    });
    await expandController.reverse();
  }
  toDetailLayout()async{
    hasExpand = false;

    setState(() {

    });
    await expandController.forward();
  }
  rememberLogin(value)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember', value);
    isRemembered = value;
    setState(() {

    });
  }
  Widget getLoginPage() {
    return Column(children: <Widget>[
      Container(
        width: _width * 0.95,
        height: _height * 0.1,
        child: Center(
          child:Transform(
            transform: Matrix4.translation(getTranslation(loginTextController)),
            child: Text(
              loginText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: loginValid ? NORMAL_COLOR : ERROR_COLOR,
                  fontSize: 18),
            ),
          )
        ),
      ),
      Container(
        height: _height * 0.45,
        width: _width * 0.8,
        child: Column(
          children: <Widget>[
            getTextField('loginEMAIL'),
            Divider(
              color: Colors.transparent,
              height: 15,
            ),
            getTextField('loginPASSWORD'),
            Divider(
              color: Colors.transparent,
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: _width*0.17),
                  child:Checkbox(
                    value: isRemembered,
                    checkColor: Colors.white,
                    activeColor: Color.fromARGB(255, 104, 111, 139),
                    onChanged: rememberLogin,
                  ) ,
                ),
                Text(
                    'Remember me',
                  style: TextStyle(
                    color: Color.fromARGB(255, 104, 111, 139),
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),
                )
              ],
            )
          ],
        ),
      ),
      Container(
          height: _height * 0.15,
          width: _width,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                color: Color.fromARGB(255, 104, 111, 139),
                width: _width * 0.8,
                height: _height * 0.07,
                child: FlatButton(
                  onPressed: onLogin,
                  child: Text(
                    'LOG IN',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              FlatButton(
                child: Text(
                  'Forgot your user name or password?',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Color.fromARGB(180, 104, 111, 139),
                  ),
                ),
              )
            ],
          ))
    ]);
  }

  Widget getRegisterPage() {
    return Column(children: <Widget>[
      Container(
        width: _width * 0.95,
        height: _height * 0.1,
        child: Center(
            child:Transform(
              transform: Matrix4.translation(getTranslation(registerTextController)),
              child: Text(
                registerText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: registerValid ? NORMAL_COLOR : ERROR_COLOR,
                    fontSize: 18),
              ),
            )
        ),
      ),
      Container(
        height: _height * 0.45,
        width: _width * 0.8,
        child: Column(
          children: <Widget>[
            getTextField('registerUSERNAME'),
            Divider(
              color: Colors.transparent,
              height: 15,
            ),
            getTextField('registerE-MAIL'),
            Divider(
              color: Colors.transparent,
              height: 15,
            ),
            getTextField('registerPASSWORD'),
            Divider(
              color: Colors.transparent,
              height: 15,
            ),
            getTextField('registerCONFIRM PASSWORD'),
          ],
        ),
      ),
      Container(
        height: _height * 0.15,
        width: _width,
        color: Colors.white,
        child: Column(children: <Widget>[
          Container(
            color: Color.fromARGB(255, 104, 111, 139),
            width: _width * 0.8,
            height: _height * 0.07,
            child: FlatButton(
              onPressed: onRegister,
              child: Text(
                'REGISTER',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]),
      )
    ]);
  }

  @override
  void initState() {
    super.initState();
    hasExpand = true;
    initRememberState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    PermissionHandler().requestPermissions([
      PermissionGroup.camera,
      PermissionGroup.microphone,
      PermissionGroup.storage
    ]);
    initAnimation();
    loginText =  'Welcome back to IBM AR Card';
    registerText = 'Register now to sync your scan history and\nfavourites, also creating your own AR card!';
  }
  initRememberState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      bool value = preferences.getBool('remember')??false;
      GlobalData globalData = GlobalData();
      globalData.hasLogin = preferences.getBool('hasLogin')??false;
      if(globalData.wantLogin){
        await toDetailLayout();
        return;
      }else if(!globalData.hasLogin){
        await Future.delayed(Duration(seconds:1));
        globalData.resumeQRViewController();
        Navigator.pushReplacement(context, FadeRoute(page: ScanQR()));
        return;
      }
      isRemembered = value;
      setState(() {
      });
      if(isRemembered){
        await restoreDetail();
        await Future.delayed(Duration(seconds:1));
        onLogin();
      }else{
        await preferences.setBool('hasLogin', false);
        globalData.hasLogin = false;
        await Future.delayed(Duration(seconds:1));
        globalData.resumeQRViewController();
        Navigator.pushReplacement(context, FadeRoute(page: ScanQR()));
        return;
      }
    });
  }

  changeToLogin() {
    if (isLogin) return;
    isLogin = true;
  //      registerPasswordConfirm.text = '';
  //      registerPassword.text = '';
  //      registerEmail.text = '';
  //      registerUserName.text = '';
    controller2.forward();
    controller1.reverse();
    setState(() {});
  }

  changeToRegister() {
    if (!isLogin) return;
    isLogin = false;
    controller1.forward();
    controller2.reverse();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    loginEMAILFocus.dispose();
    loginPasswordFocus.dispose();
    registerUserNameFocus.dispose();
    registerPasswordFocus.dispose();
    registerPasswordConfirmFocus.dispose();
    registerEmailFocus.dispose();
    loginEMAIL.dispose();
    loginPassword.dispose();
    registerUserName.dispose();
    registerPassword.dispose();
    registerPasswordConfirm.dispose();
    registerEmail.dispose();
  }
  onLogin() async{
  //      toDefaultText();
    ProgressDialog pr = new ProgressDialog(context, isDismissible: false);
    Map<String,dynamic> map = {
      "email": isLogin ? loginEMAIL.text : registerEmail.text,
      "password": isLogin ? loginPassword.text : registerPassword.text,
    };
    String value = jsonEncoder.convert(map);
    try{
      final data = await http.post('${Config.baseURl}/user/login', headers: {"Content-Type": "application/json"}, body: value).timeout(Duration(seconds: 5));
      if(data.statusCode != 200){
        var errorMsg = jsonDecoder.convert(data.body);
        throw Exception(errorMsg['error']);
      }else {
        await toDefaultLayout();
        await storeDetail();
        var Msg = jsonDecoder.convert(data.body);
        GlobalData globalData = GlobalData();
        globalData.token = Msg['token'];
        globalData.id = Msg['_id'];
        globalData.hasLogin = true;
        SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
        await sharedPreferences.setBool('hasLogin',true);
        pr.hide();
        globalData.resumeQRViewController();
        Navigator.pushReplacement(context, FadeRoute(page: ScanQR()));
      }
    }catch(err){
      vibrateLoginText();

      Vibration.vibrate(duration: 200,amplitude: 60);
      toDetailLayout();
      print(err);
      String errorCode = (err is SocketException || err is TimeoutException) ? 'Network error' : err.toString();
      if(errorCode.startsWith('Exception: ')){
        errorCode = errorCode.replaceFirst('Exception: ', '');
      }
      loginText = errorCode;
      loginValid = false;
      setState(() {

      });
    }finally{
    print('final');
    pr.hide();
    }
  }
  vibrateLoginText()async{
    await loginTextController.forward();
    await loginTextController.reverse();
  }
  vibrateRegisterText()async{
  await registerTextController.forward();
  await registerTextController.reverse();
  }
  onRegister()async{
  //    toDefaultText();
    ProgressDialog pr = new ProgressDialog(context, isDismissible: false);
    Map<String,dynamic> map = {
      "username":registerUserName.text,
      "email": registerEmail.text,
      "password": registerPassword.text,
    };
    String value = jsonEncoder.convert(map);
    try{
      print('request');
      if(registerPassword.text != registerPasswordConfirm.text){
        throw Exception('pasword must match confirm password');
      }
      pr.show();
      final data = await http.post('${Config.baseURl}/user/register', headers: {"Content-Type": "application/json"}, body: value).timeout(Duration(seconds: 5));
      pr.hide();
      if(data.statusCode != 200){
        var errorMsg = jsonDecoder.convert(data.body);
        throw Exception(errorMsg['error']);
      }else {
        var Msg = jsonDecoder.convert(data.body);
        isRemembered = true;
        pr.hide();
        await onLogin();
      }
    }catch(err){
      pr.hide();
      print(err);
      vibrateRegisterText();
      Vibration.vibrate(duration: 300,amplitude: 60);
      toDetailLayout();
      print(err);
      String errorCode = (err is SocketException || err is TimeoutException) ? 'Network error' : err.toString();
      if(errorCode.startsWith('Exception: ')){
        errorCode = errorCode.replaceFirst('Exception: ', '');
      }
      registerText = errorCode;
      registerValid =false;
      setState(() {

      });
    }finally{
    pr.hide();
    }
  }
  storeDetail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('E-MAIL', isLogin ? loginEMAIL.text : registerEmail.text);
    await preferences.setString('PASSWORD', isLogin ? loginPassword.text: registerPassword.text);
  }
  restoreDetail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    loginEMAIL.text = preferences.getString('E-MAIL');
    loginPassword.text = preferences.getString('PASSWORD');
  }
}
