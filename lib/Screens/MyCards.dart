import 'package:flutter/material.dart';
import 'package:flutter_app/Request/request.dart';
import 'dart:async';
import 'package:swipedetector/swipedetector.dart';
//import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyCards extends StatefulWidget {
  MyCards({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyCards createState() => _MyCards();
}

class _MyCards extends State<MyCards> with TickerProviderStateMixin {
  bool leave = true;
  double width;
  double height;
  bool init = false;
  double containerHeight;
  var _futureBuilderHistory;
  var _futureBuilderFavourite;
  AnimationController controller1;
  AnimationController controller2;
  Animation<Offset> offset1;
  Animation<Offset> offset2;
  Future<List> post;
  int _status = 0;
  List<String> _stringList = [
    "Favourite",
    "History",
  ];
  List<Color> _colors = [
    Colors.white,
    Colors.blue,
  ];

  void _changeToFavourite() {
    if (_status == 0) {
      return;
    }
    controller2.forward();
    controller1.reverse();
    setState(() {
      _status = 0;
    });
  }

  void _changeToHistory() {
    if (_status == 1) {
      setState(() {
        leave = true;
      });
      Navigator.pop(context);
      return;
    }
    controller1.forward();
    controller2.reverse();
    setState(() {
      _status = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    _futureBuilderHistory = _getHistory();
    _futureBuilderFavourite = _getFavourite();
    controller1 = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    controller2 = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    offset1 = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(new CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut
    ));
    offset2 = Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0)).animate(new CurvedAnimation(
        parent: controller2,
        curve: Curves.easeInOut
    ));
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        leave = false;
      });
    });
    controller2.animateTo(1, duration: Duration(milliseconds:50), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    containerHeight = height - 206;
    return new WillPopScope(
      child: Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 34, 52),
      body: Column(
        children: <Widget>[
          Container(
            child: Container(
              child: Column(children: <Widget>[
                Row(children: <Widget>[
                  Container(
                    child: Padding(
                      child: Text(
                        "MyCards\n" + _stringList[_status ^ 1],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontFamily: "IBM Plex Sans"),
                      ),
                      padding: EdgeInsets.only(top: 20.0, left: 20.0),
                    ),
                    width: 200.0,
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          color: Colors.white,
                          iconSize: 36.0,
                          onPressed: () {
                            setState(() {
                              leave = true;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        padding: EdgeInsets.only(
                            left: width - 200 - 36 - 30, top: 30),
                      ),
                      Padding(
                        child: IconButton(
                          icon: Icon(Icons.search),
                          color: Colors.white,
                          iconSize: 36.0,
                          onPressed: () {},
                        ),
                        padding: EdgeInsets.only(
                            left: width - 200 - 36 - 30, top: 10.0),
                      )
                    ],
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Align(
                      child: IconButton(
                        icon: Icon(
                          Icons.history,
                        ),
                        color: _colors[_status ^ 1],
                        iconSize: 36.0,
                        onPressed: _changeToFavourite,
                      ),
                    ),
                    Align(
                      child: IconButton(
                        icon: Icon(
                          Icons.star,
                          color: _colors[_status],
                        ),
//                        color: _colors[_status],
                        iconSize: 36.0,
                        onPressed: _changeToHistory,
                      ),
                    )
                  ],
                ),
              ]),
            ),
            color: Color.fromARGB(255, 41, 43, 66),
            height: 200.0,
            width: width,
          ),
          Container(
            child: Row(
              children: <Widget>[
                AnimatedPadding(
                  child: Container(
                    height: 6.0,
                    color: Colors.blue,
                    width: width * 0.5,
                  ),
                  padding: _status == 1
                      ? EdgeInsets.only(left: width * 0.5)
                      : EdgeInsets.only(left: 0),
                  duration: Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                ),
              ],
            ),
            color: Color.fromARGB(255, 41, 43, 66),
          ),
          SwipeDetector(
            onSwipeLeft:_changeToHistory,
            onSwipeRight:_changeToFavourite,
            child: leave ? Container() : Stack(
                children:[
                  SlideTransition(
                    position:offset1,
                    child: _getAnimatedWidgetList(1),
                  ),
                  SlideTransition(
                    position:offset2,
                    child: _getAnimatedWidgetList(0),
                  ),
                ]
            ),
          ),
        ],
      ),
    ),onWillPop: () async {
      setState(() {
        leave = true;
      });
      return true;
      },
    );
  }
  _getAnimatedWidgetList(index) {
    List<Widget> _getAnimatedWidget = [
      new SizedBox(
          width: width,
          height: containerHeight,
          child: RefreshIndicator(
            onRefresh: _handleHistoryRefresh,
            child: FutureBuilder(
              builder: _buildFuture,
              future: _futureBuilderHistory,
            ),
          )
      ),SizedBox(
          width: width,
          height: containerHeight,
          child: RefreshIndicator(
            onRefresh: _handleFavouriteRefresh,
            child: FutureBuilder(
              builder: _buildFuture,
              future: _futureBuilderFavourite,
            ),
          ))
    ];
    return _getAnimatedWidget[index];
  }

  Future _getHistory() async {
    var response = HttpUtils.get(
        'https://ar-business-card.eu-gb.cf.appdomain.cloud/HistoryList');
    return response;
  }

  Future _getFavourite() async {
    var response = HttpUtils.get(
        'https://ar-business-card.eu-gb.cf.appdomain.cloud/FavouriteList');
    return response;
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        print('request not yet started');
        return Text('request not yet started');
      case ConnectionState.active:
        print('active');
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        print('waiting');
        return Center(
          child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
//        print("done");
        if (snapshot.hasError) return errorPopup(snapshot);
        return _createListView(context, snapshot);
      default:
        return Text('request not yet started');
    }
  }
  Widget errorPopup(AsyncSnapshot snapshot ){
    return RefreshIndicator(
      child: Stack(
        children: <Widget>[
          Center(
            child: Text('Error: ${snapshot.error}'),
          ),
          ListView()
        ],
      ),
      onRefresh: _handleAllRefresh,
    );
  }
  Widget _createListView(BuildContext context, AsyncSnapshot snapshot) {
    var list = snapshot.data["List"];
    return ListView.separated(
      itemBuilder: (context, index) => _itemBuilder(context, index, list),
      itemCount: list.length + 2,
      separatorBuilder: (context, index) => Divider(
        height: 25,
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index, list) {
    if (index == 0) {
      return Divider(
        height: 5,
      );
    }
    index = index -1;
    if (index == list.length) {
      return Divider(
        height: 5,
      );
    }
    return Center(
        child: Container(
      width: width * 0.9,
      height: 100,
      decoration: new BoxDecoration(
        color: Color.fromARGB(255, 74, 79, 100),
        borderRadius: new BorderRadius.all(const Radius.circular(15.0)),
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: ClipRRect(
              borderRadius: new BorderRadius.all(const Radius.circular(50.0)),
              child: Image.network(
                list[index]["avatar"],
                width: 70,
                height: 70,
              ),
            ),
          ),
          Divider(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 12, left: 20),
                  child: SizedBox(
                    width: width - width * 0.1 - 100,
                    child: Text(
                      list[index]["name"],
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 15, left: 20),
                  child: SizedBox(
                    width: width - width * 0.1 - 100,
                    child: Text(
                      list[index]["description"],
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ],
          )
        ],
      ),
    ));
  }

  Future<Null> _handleHistoryRefresh() async {
    setState(() {
      _futureBuilderHistory = _getHistory();
    });
  }

  Future<Null> _handleFavouriteRefresh() async {
    setState(() {
      _futureBuilderFavourite = _getFavourite();
    });
  }

  Future<Null> _handleAllRefresh() async {
    _handleHistoryRefresh();
    _handleFavouriteRefresh();
  }
  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
  }
}
