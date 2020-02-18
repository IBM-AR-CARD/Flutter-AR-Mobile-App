//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart';
//import 'package:flutter_app/Models/GlobalData.dart';
//import 'package:flutter_app/Models/SlideRoute.dart';
//import 'package:flutter_app/Screens/ScanQR.dart';
//import 'package:flutter_app/Screens/UnityPage.dart';
//class BlackScreen extends StatefulWidget{
//  String direction;
//
//  BlackScreen(this.direction);
//
//  @override
//  State createState() {
//    return _BlackScreen(this.direction);
//  }
//}
//class _BlackScreen extends State<BlackScreen>{
//  String direction;
//  GlobalData globalData;
//  _BlackScreen(this.direction);
//  @override
//  void initState() {
//    super.initState();
//    globalData = GlobalData();
//    initSchedule();
//  }
//  navigateToPage()async{
//    print('blackscreen');
//    if(direction == "scanQR"){
//      await globalData.resumeQRViewController();
//      await Navigator.push(context, FadeRoute(
//        page: ScanQR(),
//      ));
//    }else if (direction == "Unity"){
//      await globalData.resumeUnityController();
//      await Navigator.push(context, FadeRoute(
//        page: UnityPage(),
//      ));
////      direction = value;
////      navigateToPage();
//    }else{
//      await Navigator.push(context, FadeRoute(
//        page: ScanQR(),
//      ));
//    }
//  }
//  initSchedule(){
//    SchedulerBinding.instance.addPostFrameCallback((_) async{
//      await navigateToPage();
//    });
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.black,
//    );
//  }
//}