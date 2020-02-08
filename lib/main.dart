import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/Login.dart';
import 'package:flutter/foundation.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Config.colorCustom,
          bottomAppBarColor: Config.colorCustom,
      ),
      debugShowCheckedModeBanner: false,
      home: Login(),
//        home:ScanQR()
    );
  }
}
