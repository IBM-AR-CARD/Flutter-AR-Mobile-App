import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Models/GlobalData.dart';
import 'package:flutter_app/Request/request.dart';
import 'package:flutter_app/Screens/Login.dart';
import '../Screens/MyCards.dart';
import '../Screens/ScanQR.dart';
import '../Models/SlideRoute.dart';
import '../Screens/Settings.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:bubble/bubble.dart';
import '../Models/BubblePair.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:flutter/foundation.dart';
import '../Models/UserData.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:swipedetector/swipedetector.dart';
class UnityPage extends StatefulWidget {
  UnityPage({Key key, this.title}) : super(key: key);
  final String title;
  final GlobalData globalData = GlobalData();

  @override
  _UnityPage createState() => _UnityPage();
}

class _UnityPage extends State<UnityPage> {
  Timer _timer;
  String currentLocal;
  final double CHAT_ORIGIN_HEIGHT = 150;
  final double CHAT_EXTEND_HEIGHT = 550;
  UnityWidgetController _unityWidgetController;
  final ScrollController bubbleScrollController = ScrollController();
  List<BubblePair> bubbleMap = new List();
  String lastWords = "";
  String lastStatus = "";
  bool isFavourite = false;
  bool _isTalking = false;
  var fetchUserData;
  final SpeechToText speech = SpeechToText();
  static final int age = 21;
  static final String name = "henry";
  GlobalData globalData = GlobalData();
  static final String description = "second year university student";
  final FlutterTts flutterTts = FlutterTts();
  bool _tracked = false;
  UserData userData;
  bool onFavouriteRequest = false;
  bool _hasExtend = false;
  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("en-US");
    isFavourite = widget.globalData.scanData.isFavourite;
    initSpeechState();
    initFlutterTTS();
  }


  initFlutterTTS() async {
    flutterTts.setCompletionHandler(() {
      _isTalking = false;
      setState(() {});
      setMessage('changeAnimator', "idle");
    });
    flutterTts.setStartHandler(() {
      _isTalking = true;
      setState(() {});
    });
  }

  stopSpeaking() async {
    _isTalking = false;
    await flutterTts.stop();
    setMessage('changeAnimator', "idle");
    setState(() {});
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
    if (!globalData.hasData) return;
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
                onPressed: navigateToMyCards,
                tooltip: 'List',
                iconSize: 40.0,
                icon: Icon(
                  Icons.list,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                  onTap: speech.isListening
                      ? stopListening
                      : (_isTalking ? stopSpeaking : startListening),
                  onPanEnd: cancelListening,
                  child: Icon(
                    speech.isListening
                        ? Icons.cancel
                        : (_isTalking ? Icons.stop : Icons.mic),
                    color: Colors.white,
                    size: 60,
                  )),
              IconButton(
                onPressed: navigateToSetting,
                tooltip: 'Person',
                iconSize: 40.0,
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ]));
  }

  changeBubbleHeight() {
    setState(() {
      _hasExtend = !_hasExtend;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: WillPopScope(
        child:SafeArea(
            child: SwipeDetector(
              onSwipeLeft: navigateToSetting,
              onSwipeRight: navigateToMyCards,
              child: Stack(
                children: <Widget>[
                  BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: _hasExtend ? 0 : 5, sigmaY: _hasExtend ? 0 : 5),
                  ),
                  UnityWidget(
                      onUnityViewCreated: onUnityCreated,
                      isARScene: true,
                      onUnityMessage: onUnityMessage),
                  Positioned.fill(
                    child: AnimatedOpacity(
                        opacity: _hasExtend ? 1 : 0,
                        duration: Duration(milliseconds: 500),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 20, sigmaX: 20),
                          child: Container(
                            color: Colors.black.withOpacity(0.3),
                          ),
                        )),
                  ),
                  bubbleChatBoard(context),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
//                  opacity:_tracked || _hasExtend ? 0 : 1 ,
                    child: _tracked || _hasExtend ? SizedBox.shrink() : flipHint(),
                  )
                ],
              ),
            )
    ),
          onWillPop: ()async{
          navigateToScan();
          return false;
          },
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
    if (message == '#tracked#' && !_tracked) {
      _tracked = true;
      talk("Nice to meet you, I am " +
          widget.globalData.scanData.firstName +
          ', please click the mic icon to ask any questions.');
    }
    setState(() {});
  }

// Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    this._unityWidgetController = controller;
    globalData.unityWidgetController = controller;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
//    globalData.unityWidgetController = null;
  }

  updateGender() {
    if (widget.globalData.scanData.gender == 2) {
      flutterTts.setVoice('en-gb-x-fis#male_1-local');
    } else {
      flutterTts.setVoice('en-gb-x-gba-network');
    }
    setMessage("changeCharacter", widget.globalData.scanData.model);
    setState(() {});
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
    if (userData == null) {
      _firstName = "";
      _lastName = "";
      _avatar = "";
      _username = "";
    } else {
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
                              ]),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
//                      crossAxisAlignment:CrossAxisAlignment.end,
                    children: <Widget>[
                      widget.globalData.hasLogin ? IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: IconShadowWidget(
                          Icon(
                            Icons.favorite,
                            size: 30,
                            color: isFavourite
                                ? Color.fromRGBO(15, 232, 149, 1)
                                : Colors.white,
                          ),
                          shadowColor: Colors.greenAccent.shade200,
                          showShadow: isFavourite,
                        ),
                        onPressed: _onFavourite
                      ):SizedBox.shrink(),
                      IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: IconShadowWidget(
                          Icon(
                            Icons.question_answer,
                            size: 30,
                            color: _hasExtend
                                ? Color.fromRGBO(15, 232, 149, 1)
                                : Colors.white,
                          ),
                          shadowColor: Colors.greenAccent.shade200,
                          showShadow: _hasExtend,
                        ),
                        onPressed: () {
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
  navigateToMyCards()async{
    if (!globalData.hasLogin){
      globalData.wantLogin = true;
      _tracked = false;
      globalData.stopAllController();
      await Navigator.push(
          context,
          FadeRoute(
            page: Login(),
          ));
    }else{
      await Navigator.push(context, SlideRightRoute(page: MyCards()));
    }
  }
  _onFavourite()async{
    if(onFavouriteRequest) return;
    try{
      if(isFavourite){
        final response = await RequestCards.favouriteRemove(widget.globalData.scanData.id);
        if(response.statusCode == 200){
          isFavourite = false;
          widget.globalData.scanData.isFavourite = false;
        }else{
          throw Exception();
        }
      }else{
        final response = await RequestCards.favouriteAdd(widget.globalData.scanData.id);
        if(response.statusCode == 200){
          isFavourite = true;
          widget.globalData.scanData.isFavourite = true;
        }else{
          throw Exception();
        }
      }
    }catch(err){
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Network Error"),
              content: new Text("please contact admin"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }finally{
      onFavouriteRequest = false;
      setState(() {

      });
    }
  }
  navigateToScan() async {
    _tracked = false;
    globalData.resumeQRViewController();
    await Navigator.push(context, FadeRoute(page: ScanQR()));
    updateGender();
    setState(() {});
  }
  navigateToSetting()async{
    _tracked = false;
    if (!globalData.hasLogin){
      globalData.wantLogin = true;
      await globalData.stopAllController();
      await Navigator.push(
          context,
          FadeRoute(
            page: Login(),
          ));
    }else{
      globalData.stopAllController();
      await Navigator.push(context, SlideLeftRoute(page: Settings()));
      updateGender();
      setMessage("changeCharacter", widget.globalData.scanData.model);
    }
    setState(() {

    });
  }

  flipHint() {
    return Align(
        alignment: Alignment(0, 0.5),
        child: Opacity(
          opacity: 0.8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(const Radius.circular(50.0)),
            ),
            width: 280,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.rotate_90_degrees_ccw,
                  size: 35,
                  color: Colors.black,
                ),
                Padding(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Flip you card and scan the\nimage to view the avatar',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(left: 10),
                )
              ],
            ),
          ),
        ));
  }
}
