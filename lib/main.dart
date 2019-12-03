import 'package:flutter/material.dart';
import 'Screens/MyCards.dart';
import 'Screens/scanQR.dart';
import 'Models/SlideRoute.dart';
import 'Screens/Settings.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentColor = 1;
  String _QRText = 'QR';
  UnityWidgetController _unityWidgetController;
  List<Color> _colors = [ //Get list of colors
    Color.fromARGB(255,112,112,112),
    Color.fromARGB(255,15,232,149),
  ];

  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
  void navigateToScan() async {
    _unityWidgetController.pause();
    final result = await Navigator.push(
      context,
      SlideTopRoute(page:ScanQR()),
    );
    setState(() {
      _QRText = result == '' ? 'QR' : result;
    });
    _unityWidgetController.resume();

//    setState(() {
//      _currentColor = _currentColor ^ 1;
//    });
  }
  Widget bottomRow(){
        return new Padding(
          padding: const EdgeInsets.all(50.0),
          child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:<Widget>[
              IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    SlideRightRoute(page:MyCards()),
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
                onPressed: (){
                  Navigator.push(
                    context,
                    SlideLeftRoute(page:Settings()),
                  );
                },
                tooltip: 'Person',
                iconSize: 40.0,
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
          ]
          )
        );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: _currentColor==1? 1 : 0,
              child: UnityWidget(
                onUnityViewCreated: onUnityCreated,
                isARScene: true,
                onUnityMessage: onUnityMessage
              )
            ),
            Padding(
              padding: EdgeInsets.only(top:70.0,left: 20.0),
              child: FlatButton(
                child: new  Text(
                    _QRText,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 40.0,
                      color: _colors[_currentColor],
                    ),
                ),
                onPressed: navigateToScan,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ),
          ],
        ),

      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:bottomRow()

    );
  }

  void onUnityMessage(controller, message) {
    print('Received message from unity: ${message.toString()}');
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
  }
  @override
  void dispose() {
    super.dispose();
  }
}
