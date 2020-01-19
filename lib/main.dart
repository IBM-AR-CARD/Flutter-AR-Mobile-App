import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Models/GlobalData.dart';
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
import 'package:icon_shadow/icon_shadow.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/UserData.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:swipedetector/swipedetector.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
//        home:ScanQR()
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  final GlobalData globalData = GlobalData();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _hasData = false;
  Timer _timer;
  bool _hasScaned = false;
  String currentLocal;
  final double CHAT_ORIGIN_HEIGHT = 150;
  final double CHAT_EXTEND_HEIGHT = 600;
  UnityWidgetController _unityWidgetController;
  final ScrollController bubbleScrollController = ScrollController();
  bool _hasSpeech = false;
  List<BubblePair> bubbleMap = new List();
  String lastWords = "";
  String lastStatus = "";
  var fetchUserData;
  final SpeechToText speech = SpeechToText();
  static final int age = 21;
  static final String name = "henry";
  static final String description = "second year university student";
  final FlutterTts flutterTts = FlutterTts();
  UserData userData;
  bool _hasExtend = false;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    flutterTts.setLanguage("en-US");
    initSpeechState();
    fetchUserData = fetchPost();
    initFlutterTTS();
  }

  initFlutterTTS() async {
    flutterTts.setCompletionHandler(() {
      setMessage('changeAnimator', "idle");
    });
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
//    bubbleMap.add(BubblePair(text, BubblePair.FROM_OTHER));
    bubbleMap.insert(0, BubblePair(text, BubblePair.FROM_OTHER));
    setState(() {});
    await flutterTts.speak("$text");
    bubbleScrollController.animateTo(0.0,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  speak() async {
    UserData userData = GlobalData().scanData;
    String text = lastWords.toLowerCase();
    print('recognized text : $text');
    if (text.contains("name") || text.contains("who")) {
      await talk("Hello! My name is " +
          userData.firstName.toString() +
          " " +
          userData.lastName.toString());
    } else if (text.contains("tell me about") || text.contains("description")) {
      await talk(userData.description);
    } else if (text.contains("experience") ||
        text.contains("work") ||
        text.contains("company")) {
      await talk(userData.experience);
    } else if (text == "start dancing") {
      setMessage('changeAnimator', "dancing");
    } else if (text == "random character") {
      setMessage('randomModel', '');
    } else if (text.contains("education") ||
        text.contains("university") ||
        text.contains("study")) {
      await talk(userData.education);
    } else {
      await talk("Sorry, I haven't learned that yet.");
    }
  }

  void startListening() {
    if (!_hasData || !_hasScaned) return;
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
//      bubbleMap.add(BubblePair(lastWords, BubblePair.FROM_ME));
      bubbleMap.insert(0, BubblePair(lastWords, BubblePair.FROM_ME));
      setState(() {});
      await speak();
      await bubbleScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
    }
    ;
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
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
              GestureDetector(
                  onTap: speech.isListening ? stopListening : startListening,
                  onPanEnd: cancelListening,
                  child: Icon(
                    speech.isListening ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 60,
                  )),
              IconButton(
                onPressed: () async{
                  if (!_hasData) return;
                  await Navigator.push(
                    context,
                    SlideLeftRoute(
                      page: Settings(),
                    ),
                  );
                  updateGender();
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

  changeBubbleHeight() {
    setState(() {
      _hasExtend = !_hasExtend;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
        body: Container(
          child:SwipeDetector(
            onSwipeLeft: () async{
              if (!_hasData) return;
              await Navigator.push(
                context,
                SlideLeftRoute(
                  page: Settings(),
                ),
              );
              updateGender();
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
                UnityWidget(
                    onUnityViewCreated: onUnityCreated,
                    isARScene: true,
                    onUnityMessage: onUnityMessage
                ),
                bubbleChatBoard(context),
                Center(
                  child: FutureBuilder<void>(
                    future: fetchUserData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox.shrink();
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: bottomRow()
    );
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

  Future<void> fetchPost() async {
    final retry = RetryOptions(maxAttempts: 16);
    final response = await retry.retry(
      // Make a GET request
      () => http
          .get('http://51.11.45.102:8080/profile/get')
          .timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    await fetchPostedData(response);
    if(!_hasScaned){
      await navigateToScan();
    }

  }

  fetchPostedData(response) async {
    if (response.statusCode == 200) {
      userData = UserData.toUserData(response.body);
      SharedPreferences storeValue = await SharedPreferences.getInstance();
      storeValue.setString("UserData", response.body);
      widget.globalData.userData = userData;
      _hasData = true;
      widget.globalData.hasData = true;
      setState(() {});

    }
  }
  updateGender(){
    if (widget.globalData.scanData.gender == 2) {
      flutterTts.setVoice('en-gb-x-fis#male_1-local');
    } else {
      flutterTts.setVoice('en-gb-x-gba-network');
    }
    setState(() {
      
    });
  }
  Widget bubbleChatBoard(context) {
    UserData userData = widget.globalData.scanData;
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;
    String _firstName;
    String _lastName;
    String _avatar;
    String _username;
    if(userData == null){
      _firstName  = "";
      _lastName = "";
      _avatar = "";
      _username= "";
    }else{
      _firstName = userData.firstName;
      _lastName = userData.lastName;
      _avatar = userData.profile;
      _username = userData.userName;
    }
    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 5 * px,
      margin: BubbleEdges.only(top: 8.0, right: 10.0),
      alignment: Alignment.topLeft,
    );
    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 5 * px,
      margin: BubbleEdges.only(top: 8.0, left: 10.0),
      alignment: Alignment.topRight,
    );
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0, 1.0],
                colors: [Colors.transparent, Color.fromARGB(230, 10, 10, 10)],
              ),
            ),
            height: _height * 0.15,
            width: _width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          child: ClipRRect(
                            borderRadius: new BorderRadius.all(
                                const Radius.circular(40.0)),
                            child: FadeInImage(
                              image: NetworkImage(_avatar),
                              placeholder: AssetImage(
                                  'assets/images/unknown-avatar.jpg'),
                            ),
                          ),
                          height: 60.0,
                          width: 60.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: _width * 0.4,
                                  child: AutoSizeText(
                                    _firstName.toString() +
                                        " " +
                                        _lastName.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40),
                                    minFontSize: 20,
                                    maxFontSize: 25,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: _width * 0.4,
                                  child: AutoSizeText(
                                    _username,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40),
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ]
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right:10),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.end,
//                      crossAxisAlignment:CrossAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: IconShadowWidget(
                          Icon(
                            Icons.question_answer,
                            size: 30,
                            color: _hasExtend ? Color.fromRGBO(15, 232, 149, 1):Colors.white ,
                          ),
                          shadowColor: Colors.greenAccent.shade200,
                          showShadow: _hasExtend,
                        ),
                        onPressed: (){
                          setState(() {
                            _hasExtend = !_hasExtend;
                          });
                        },
                      ),
                      IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            Icons.exit_to_app,
                            size: 30,
                            color: Colors.white,
                          ),
                        onPressed: navigateToScan
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [_hasExtend ? 0.95 : 0.6, 1.0],
                    colors: [Colors.black, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: GestureDetector(
                  onDoubleTap: changeBubbleHeight,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height:
                        _hasExtend ? CHAT_EXTEND_HEIGHT : CHAT_ORIGIN_HEIGHT,
                    child: Opacity(
                        opacity: _hasExtend ? 0.9 : 0.3,
                        child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          reverse: true,
                          itemCount: bubbleMap.length,
                          controller: bubbleScrollController,
                          itemBuilder: (BuildContext ctxt, int Index) {
                            BubblePair bubble;
                            bubble = bubbleMap.elementAt(Index);
                            if (bubble.type == BubblePair.FROM_ME) {
                              return Bubble(
                                style: styleMe,
                                child: Text(
                                  bubble.content,
                                  style: TextStyle(fontSize: 15),
                                ),
                              );
//                              return Bubble(
//                                style: styleMe,
//                                child: Text(
//                                  bubble.content,
//                                  style: TextStyle(fontSize: 15),
//                                ),
//                              );
                            } else {
                              return Bubble(
                                style: styleSomebody,
                                child: Text(
                                  bubble.content,
                                  style: TextStyle(fontSize: 15),
                                ),
                              );
                            }
                          },
                        )),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
  navigateToScan()async{
    _hasScaned = false;
    await _unityWidgetController.pause();
    final result = await Navigator.push(context, FadeRoute(page:ScanQR()));
    updateGender();
    print(result);
    _hasScaned=true;
    _unityWidgetController.resume();
    setState(() {});
  }
}
