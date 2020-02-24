import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/BlackScreen.dart';
import 'package:flutter_app/Screens/Login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/Screens/MyCards.dart';
import 'package:flutter_app/Screens/PersonDetail.dart';
import 'package:flutter_app/Screens/ScanQR.dart';
import 'package:flutter_app/Screens/Settings.dart';
import 'package:flutter_app/Screens/UnityPage.dart';
import 'Models/Config.dart';
void main() async {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => UnityPage(),
//        '/UnityPage' : (context) => UnityPage(),
        '/ScanQR':(context) => ScanQR(),
        '/MyCards':(context) => MyCards(),
        '/Login':(context) => Login(),
        '/Settings':(context) => Settings(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Config.colorCustom,
          bottomAppBarColor: Config.colorCustom,
      ),
      debugShowCheckedModeBanner: false,
//        home:UnityPage()
    );
  }
}
