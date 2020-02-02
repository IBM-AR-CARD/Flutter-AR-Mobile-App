import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Models/SlideRoute.dart';
import 'package:flutter_app/Screens/ScanQR.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swipedetector/swipedetector.dart';
import '../Models/Config.dart';
class Login extends StatefulWidget {
  @override
  State createState() => _Login();
}

class _Login extends State<Login> with TickerProviderStateMixin {
  double _width;
  double _height;
  bool isLogin = true;
  TextEditingController loginUserName = TextEditingController();
  TextEditingController loginPassword = TextEditingController();
  TextEditingController registerUserName = TextEditingController();
  TextEditingController registerPassword = TextEditingController();
  TextEditingController registerPasswordConfirm = TextEditingController();
  TextEditingController registerEmail = TextEditingController();
  Animation<Offset> offset1;
  Animation<Offset> offset2;
  AnimationController controller1;
  AnimationController controller2;
  List<Widget> inputFields = List();
  FocusNode loginUserNameFocus = FocusNode();
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
  initTextField() {
    inputFields.add(getTextField('USERNAME'));

  }

  initAnimation() {
    controller1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    controller2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    offset1 = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
        .animate(
        new CurvedAnimation(parent: controller1, curve: Curves.easeInOut));
    offset2 = Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
        .animate(
        new CurvedAnimation(parent: controller2, curve: Curves.easeInOut));
    controller2.animateTo(1,
        duration: Duration(milliseconds: 50), curve: Curves.easeInOut);
  }

  Widget getTextField(String name) {
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: Container(
            width: _width,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 219, 220, 230),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: TextFormField(
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
      case 'loginUSERNAME':
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
      case 'loginUSERNAME':
        return 'USERNAME';
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
      case 'loginUSERNAME':
        return loginUserNameFocus;
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
        case 'loginUSERNAME':
          return loginUserName;
        case 'loginPASSWORD':
          return loginPassword;
      }
    }

    Icon getPrefixIcon(String name) {
      switch (name) {
        case 'loginUSERNAME':
          return Icon(
            Icons.person,
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

    Widget _buildTextField(BuildContext context, int index,
        Animation<double> animation) {
      if (isLogin) {
        if (index == 0) {
          return getTextField('USERNAME');
        } else if (index == 1) {
          return getTextField('PASSWORD');
        }
      } else {
        if (index == 0) {
          return getTextField('USERNAME');
        } else if (index == 1) {
          return getTextField('E-MAIL');
        } else if (index == 2) {
          return getTextField('PASSWORD');
        } else if (index == 3) {
          return getTextField('CONFIRM PASSWORD');
        }
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
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: SwipeDetector(
          onSwipeLeft: changeToRegister,
          onSwipeRight: changeToLogin,
          child:Container(
                  color: Colors.white,
                  width: _width,
                  height: _height,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: _height * 0.2,
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
                      Stack(children: [
                        SlideTransition(
                          position: offset1,
                          child: getRegisterPage(),
                        ),
                        SlideTransition(
                          position: offset2,
                          child: getLoginPage(),
                        ),
                      ]),
                    ],
                  ),
                )
            )
        )
      );
    }

    Widget getLoginPage() {
      return Column(children: <Widget>[
        Container(
          width: _width * 0.95,
          height: _height * 0.1,
          child: Center(
            child: Text(
              loginText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: loginValid ? NORMAL_COLOR : ERROR_COLOR,
                  fontSize: 18),
            ),
          ),
        ),
        Container(
          height: _height * 0.45,
          width: _width * 0.8,
          child: Column(
            children: <Widget>[
              getTextField('loginUSERNAME'),
              Divider(
                color: Colors.transparent,
                height: 15,
              ),
              getTextField('loginPASSWORD'),
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
            child: Text(
              registerText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: registerValid ? NORMAL_COLOR : ERROR_COLOR,
                  fontSize: 18),
            ),
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
      initTextField();
      initAnimation();
      loginText =  'Welcome back to IBM AR Card';
      registerText = 'Register now to sync your scan history and\nfavourites, also creating your own AR card!';
      SystemChrome.setEnabledSystemUIOverlays([]);
      PermissionHandler().requestPermissions([
        PermissionGroup.camera,
        PermissionGroup.microphone,
        PermissionGroup.storage
      ]);
    }

    changeToLogin() {
      if (isLogin) return;
      isLogin = true;
      registerPasswordConfirm.text = '';
      registerPassword.text = '';
      registerEmail.text = '';
      registerUserName.text = '';
      controller2.forward();
      controller1.reverse();
      setState(() {});
    }

    changeToRegister() {
      if (!isLogin) return;
      isLogin = false;
      loginPassword.text = '';
      loginUserName.text = '';
      controller1.forward();
      controller2.reverse();
      setState(() {});
    }

    @override
    void dispose() {
      super.dispose();
      controller1.dispose();
      controller2.dispose();
      loginUserNameFocus.dispose();
      loginPasswordFocus.dispose();
      registerUserNameFocus.dispose();
      registerPasswordFocus.dispose();
      registerPasswordConfirmFocus.dispose();
      registerEmailFocus.dispose();
      loginUserName.dispose();
      loginPassword.dispose();
      registerUserName.dispose();
      registerPassword.dispose();
      registerPasswordConfirm.dispose();
      registerEmail.dispose();
    }
    onLogin() {
      Navigator.push(context, FadeRoute(page: ScanQR()));
    }
    bool validInput() {
      if (isLogin) {

      } else {
        if (registerPassword.text == "" || registerPasswordConfirm.text == "" || registerUserName.text == "" || registerEmail.text == "") {
          registerText = 'input must not be empty';
          registerValid = false;
          setState(() {

          });
          return false;
        } else if (registerPassword.text != registerPasswordConfirm.text){
          registerText = 'Password does not match to Confirm password';
          registerValid = false;
          setState(() {

          });
          return false;
        }
      }
      return true;
    }
    onRegister(){
      validInput();

    }
}
