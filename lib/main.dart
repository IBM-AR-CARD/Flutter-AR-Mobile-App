import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Screens/MyCards.dart';
import 'Screens/scanQR.dart';
import 'Models/SlideRoute.dart';
import 'Screens/Settings.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
  Timer _timer;
  int _currentColor = 1;
  int _start = 0;
  String _QRText = 'QR';
  UnityWidgetController _unityWidgetController;
  List<Color> _colors = [
    //Get list of colors
    Color.fromARGB(255, 112, 112, 112),
    Color.fromARGB(255, 15, 232, 149),
  ];
  bool _hasSpeech = false;
  String lastWords = "";
  String lastStatus = "";
  final SpeechToText speech = SpeechToText();
  static final int age = 21;
  static final String name = "henry";
  static final String description = "second year university student";
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    flutterTts.setLanguage("en-US");
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(onStatus: statusListener);

    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }
  talk(String text)async {
    setMessage('changeAnimator', "talking");
    await flutterTts.speak("text");
    setMessage('changeAnimator', "idle");
  }
  speak(String text) async {
    text = text.toLowerCase();
    if (text.contains("age")) {
      await talk("I am $age years old");
    } else if (text.contains("name")) {
      await talk("my name is $name");
    } else if (text.contains("description")) {
      await talk("$description");
    }
    if(lastWords=="start talking"){
      setMessage('changeAnimator', "talking");
    }
    if(lastWords=="stop"){
      setMessage('changeAnimator', "idle");
    }
    if(lastWords=="start dancing"){
      setMessage('changeAnimator', "dancing");
    }
    if(lastWords=="random character"){
      setMessage('randomModel', '');
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start > 30) {
            stopListening();
            _timer.cancel();
            _start = 0;
          } else if (speech.isListening) {
            _start = _start + 1;
          } else {
            _start = 0;
          }
        },
      ),
    );
  }

  void startListening() {
    startTimer();
    lastWords = "";
    speech.listen(onResult: resultListener);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
    });
  }

  void cancelListening(ctx ) async{
    speech.cancel();
    setState(() {
      speak(lastWords);
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords}";
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }


  void navigateToScan() async {
    setMessage('changeText', "opened scan");
    _unityWidgetController.pause();
    final result = await Navigator.push(
      context,
      SlideTopRoute(page: ScanQR()),
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

  Widget bottomRow() {
    return new Padding(
        padding: const EdgeInsets.all(50.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {
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
              GestureDetector(
                  onTap: speech.isListening ? stopListening : startListening,
                  onPanEnd: cancelListening,
                  child: Icon(
                    speech.isListening ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 60,
                  )),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    SlideLeftRoute(page: Settings()),
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Stack(
            children: <Widget>[
              Opacity(
                  opacity: _currentColor == 1 ? 1 : 0,
                  child: UnityWidget(
                      onUnityViewCreated: onUnityCreated,
                      isARScene: true,
                      onUnityMessage: onUnityMessage)),
              Center(
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Text('$lastWords : $_start'),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 70.0, left: 20.0),
                child: FlatButton(
                  child: new Text(
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
        floatingActionButton: bottomRow());
  }

  void setMessage(String function, String msg) {
    print("Sending message to unity: " + msg);
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
