import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Models/GlobalData.dart';
import 'package:flutter_app/Screens/LoginPopUp.dart';
import 'Screens/MyCards.dart';
import 'Screens/ScanQR.dart';
import 'Models/SlideRoute.dart';
import 'Screens/Settings.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:bubble/bubble.dart';
import 'Models/BubblePair.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:flutter/foundation.dart';
import 'Models/UserData.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:permission_handler/permission_handler.dart';

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
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: ScanQR(),
//        home:ScanQR()
    );
  }
}
