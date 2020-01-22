import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import '../Models/SlideRoute.dart';
import '../Screens/MyCards.dart';
import '../Screens/Settings.dart';
import '../Models/GlobalData.dart';
import 'package:swipedetector/swipedetector.dart';
import '../Models/UserData.dart';
import 'package:progress_dialog/progress_dialog.dart';
class ScanQR extends StatefulWidget {
  ScanQR({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ScanQR createState() => _ScanQR();
}

class _ScanQR extends State<ScanQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  QRViewController controller;
  bool _hasData = false;
  bool _find = false;
  @override
  void initState() {
    super.initState();
    _hasData = GlobalData().hasData;
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return WillPopScope(
      child: Scaffold(
        body: SwipeDetector(
          onSwipeLeft: () {
            if (!_hasData) return;
            Navigator.push(
              context,
              SlideLeftRoute(
                page: Settings(),
              ),
            );
          },
          onSwipeRight: () {
            if (!_hasData) return;
            Navigator.push(
              context,
              SlideRightRoute(page: MyCards()),
            );
          },
            child: Stack(
              children: <Widget>[
                Container(
                  height: _height,
                  width: _width,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0, 1.0],
                        colors: [
                          Colors.transparent,
                          Color.fromARGB(230, 10, 10, 10)
                        ],
                      ),
                    ),
                    height: _height * 0.17,
                    width: _width,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.help_outline,
                            size: 50,
                            color: Colors.white,
                          ),
                          Padding(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Scan a card to begin',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text:'Doesn’t have a card? Try a ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'demo',
                                        style: TextStyle(
                                          decoration:  TextDecoration.underline
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = ()async{
                                          ProgressDialog pr;
                                          try {
                                            pr = new ProgressDialog(context, isDismissible: false);
                                            pr.show();
                                            await setDemoUserData("demo");
                                          }finally{
                                            pr.hide();
                                          }
                                            _find = true;
                                            Navigator.of(context).pop();
                                          }
                                      ),
                                      TextSpan(
                                          text: ' here.',
                                      ),
                                    ]
                                  )
//                                  'Doesn’t have a card? Try a demo here.',
                                ),
                              ],
                            ),
                            padding: EdgeInsets.only(left: 10),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment(0, 0.5),
                    child: Opacity(
                      opacity: 0.8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.all(const Radius.circular(50.0)),
                        ),
                        width: 280,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.center_focus_weak,
                              size: 35,
                              color: Colors.black,
                            ),
                            Padding(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Point the camera to the QR\nCode on the business card',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.only(left: 10),
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            ),

        ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          floatingActionButton: bottomRow()
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!_find) {
        _find = true;
        if(scanData.startsWith("url")){
          GlobalData().scanData = GlobalData().userData;
//          Navigator.pop(context);
        }else{
          await setDemoUserData(scanData);
        }
        Navigator.of(context).pop();
      }
    });
  }
  setDemoUserData(scanData)async{
    GlobalData globalData = GlobalData();
    UserData userData = await Future.delayed(Duration(seconds: 2),(){
      globalData = GlobalData();
      return globalData.userData;
//      return UserData("5e1f1c1228d7d94fdb721ad2","John","McNamara","https://media-exp2.licdn.com/dms/image/C5603AQFA_oQhi6-2Cg/profile-displayphoto-shrink_800_800/0?e=1584576000&v=beta&t=QfVEJg5DU7IHXBiUlaZ2nRjI5gHTqok20eL17iHHa8Y","jonmcnamara",
//          education: "I have studied at University of Humberside, on Field Of StudyInformation Systems. And received a 2:1 Grade. ",
//          gender: 2,
//          description:"John is a Senior Inventor, Research Fellow, Impact Fellow and currently provides technical leadership for the IBM Hursley Innovation Centre. John has a diverse background that includes consultancy, performance, service & product delivery, all underpinned by a passion for innovation. Most recently his work leading the Innovation Centre technologist team has allowed him to combine these interests in order to maximise the potential of new technology while solving real problems. John has overseen the delivery of many cognitive cloud-based solutions and understands how to combine technologies to quickly provide value for customers. John is an active inventor with an invention portfolio spanning mobile, A.I, messaging, integration and predictive analytics. "
//      );
    }
    );
    globalData.scanData = userData;
  }
  Widget bottomRow() {
    return new Padding(
        padding: const EdgeInsets.all(50.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  if (!_hasData) return;
                  Navigator.push(
                    context,
                    SlideRightRoute(page: MyCards()),
                  );
                },
                tooltip: 'List',
                iconSize: 40.0,
                icon: Icon(
                  Icons.list,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  if (!_hasData) return;
                  Navigator.push(
                    context,
                    SlideLeftRoute(
                      page: Settings(),
                    ),
                  );
                },
                tooltip: 'Person',
                iconSize: 40.0,
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ]));
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
