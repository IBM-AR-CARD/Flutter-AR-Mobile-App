import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Screens/MyCards.dart';
import 'Screens/scanQR.dart';
import 'Models/SlideRoute.dart';
import 'Screens/Settings.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
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
  bool _isAvailable = false;
  bool _isListening = false;
  String resultText = "";
  Timer _timer;
  SpeechRecognition _speechRecognition;
  int _currentColor = 1;
  int _start = 0;
  String _QRText = 'QR';
  UnityWidgetController _unityWidgetController;
  List<Color> _colors = [ //Get list of colors
    Color.fromARGB(255,112,112,112),
    Color.fromARGB(255,15,232,149),
  ];
  static final int age = 21;
  static final String name = "henry";
  static final String description = "second year university student";
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    initSpeechRecognizer();
  }

  speak (String text) async{
    text = text.toLowerCase();
    if(text.contains("age")){
      await flutterTts.speak("I am $age years old");
    }else if(text.contains("name")){
      await flutterTts.speak("my name is $name");
    }else if(text.contains("description")){
      await flutterTts.speak("$description");
    }
  }
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start > 30) {
            recordEnd();
            _timer.cancel();
            _start = 0;
          } else if(_isListening) {
            _start = _start + 1;
          }else{
            _start = 0;
          }
        },
      ),
    );
  }

  void initSpeechRecognizer(){
    _speechRecognition = SpeechRecognition();
    _speechRecognition.setAvailabilityHandler(
            (bool result ) => setState(()=> _isAvailable=result)
    );
    _speechRecognition.setRecognitionStartedHandler(()=>setState(
            ()=>_isListening=true)
    );
    _speechRecognition.setRecognitionResultHandler(
            (String speech)=>setState((){
              resultText=speech;
              speak(resultText);
              if(resultText=="start talking"){
                setMessage('changeAnimator', "talking");
              }
              if(resultText=="stop"){
                setMessage('changeAnimator', "idle");
              }
              if(resultText=="start dancing"){
                setMessage('changeAnimator', "dancing");
              }
              if(resultText=="random character"){
                setMessage('randomModel', '');
              }
            })
    );

    _speechRecognition.setRecognitionCompleteHandler(()=>setState(
            ()=>_isListening=false)
    );
    _speechRecognition.activate().then(
            (result) => setState(()=>_isAvailable=result)
    );
  }

  void navigateToScan() async {
    setMessage('changeText', "opened scan");
    _unityWidgetController.pause();
    final result = await Navigator.push(
      context,
      SlideTopRoute(page:ScanQR()),
    );
    setState(() {
      _QRText = result == '' ? 'QR' : result;

    });
    await _unityWidgetController.resume();
    setMessage('changeText', _QRText);

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
              GestureDetector(
                onTap: _isListening ? recordEnd : recordStart,
                onPanEnd: recordCancel,
                child: Icon(
                  _isListening ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: 60,
                )

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
  void recordStart(){
    if(_isAvailable && !_isListening){
      _start = 0;
      startTimer();
      print("start record");
      _speechRecognition.listen(locale: "en_GB").then(
          (result) => print('record : $result')
      );
    }
  }
  void recordEnd(){
    print("_isAvailable : $_isAvailable");
    if(_isListening && _start>5) {
      _speechRecognition.stop().then(
              (result) => setState(() {
                _start = 0;
                _isListening = result;
              }));
    }
  }
  void recordCancel(ctx){
      if(_isListening)
        _speechRecognition.cancel().then((result)=>setState((){

          _isListening = result;
          resultText = "";
        }));
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
            Center(
              child: Opacity(
                opacity: 0.5,
                child: Container(
                  width: MediaQuery.of(context).size.width*0.6,
                  height: 40,
                  decoration: BoxDecoration(
                    color:Colors.white,
                  ),
                  child:Text('$resultText : $_start'),
              ),
            ),
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

  void setMessage(String function, String msg) {
    print("Sending message to unity: "+msg);
    _unityWidgetController.postMessage(
      'Main Camera',
      function,
      msg,
    );
  }

  void onUnityMessage(controller, message) {
    print('Received message from unity: ${message.toString()}');
    setState(() {
      _QRText = message.toString();
    });

  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
