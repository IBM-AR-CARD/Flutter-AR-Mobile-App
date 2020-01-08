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
import 'package:bubble/bubble.dart';
import 'Models/BubblePair.dart';
import 'package:flutter/foundation.dart';

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
  String _QRText = 'QR';
  String currentLocal;
  UnityWidgetController _unityWidgetController;
  final ScrollController bubbleScrollController = ScrollController();
  List<Color> _colors = [
    //Get list of colors
    Color.fromARGB(255, 112, 112, 112),
    Color.fromARGB(255, 15, 232, 149),
  ];
  bool _hasSpeech = false;
  List<BubblePair> bubbleMap = new List();
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

  initLocal() async {
    List<LocaleName> locales = await speech.locales();
    bool hasen_US = false;
    for (LocaleName local in locales) {
      if (local.localeId == 'en_US') {
        hasen_US = true;
      }
    }
    if (hasen_US) {
      currentLocal = 'en_US';
    } else {
      currentLocal = 'en_GB';
    }
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(onStatus: statusListener);
    await initLocal();
    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  talk(String text) async {
    setMessage('changeAnimator', "talking");
    bubbleMap.insert(0,BubblePair(text, BubblePair.FROM_OTHER));
    setState(() {});
    await flutterTts.speak("$text");
    await bubbleScrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn);
    setMessage('changeAnimator', "idle");
  }

  speak() async {
    String text = lastWords.toLowerCase();
    print('recognized text : $text');
    if (text.contains("age")) {
      await talk("I am $age years old");
    } else if (text.contains("name")) {
      await talk("my name is $name");
    } else if (text.contains("description")) {
      await talk("$description");
    } else if (text == "start dancing") {
      setMessage('changeAnimator', "dancing");
    } else if (text == "random character") {
      setMessage('randomModel', '');
    }
  }

  void startListening() {
    _hasSpeech = true;
    lastWords = "";
    speech.listen(
        listenFor: Duration(seconds: 25),
        localeId: currentLocal,
        onResult: resultListener);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {});
  }

  void cancelListening(ctx) async {
    speech.cancel();
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) async {
    lastWords = "${result.recognizedWords}";
    if (result.finalResult) {
      bubbleMap.insert(0,BubblePair(lastWords, BubblePair.FROM_ME));
      setState(() {
      });
      await speak();
      await bubbleScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 200),
          curve: Curves.bounceIn);
    };
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
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;
    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );
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
              Padding(
                padding: EdgeInsets.only(top: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Opacity(
                      opacity: 0.7,
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 200,
                          child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              reverse: true,
                              controller: bubbleScrollController,
                              itemBuilder: (BuildContext ctxt, int Index) {
                                BubblePair bubble = bubbleMap.elementAt(Index);
                                if (bubble.type == BubblePair.FROM_ME) {
                                  return Bubble(
                                    style: styleMe,
                                    child: Text(bubble.content),
                                  );
                                } else {
                                  return Bubble(
                                    style: styleSomebody,
                                    child: Text(bubble.content),
                                  );
                                }
                              },
                              itemCount: bubbleMap.length)),
                    ),
                  ],
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
