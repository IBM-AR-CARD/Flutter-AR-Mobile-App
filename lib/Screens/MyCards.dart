import 'package:flutter/material.dart';
import 'package:flutter_app/Request/request.dart';
import 'dart:async';

class MyCards extends StatefulWidget {
  MyCards({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyCards createState() => _MyCards();
}

class _MyCards extends State<MyCards> {
  double width;
  double height;
  var _futureBuilderFuture;
  Future<List> post;
  int _status = 0;
  List<String> _stringList = [
    "Favourite",
    "History",
  ];
  List<Color> _colors = [
    //Get list of colors
    Colors.white,
    Colors.blue,
  ];

  void _changeToFavourite() {
    if (_status == 0) {
      return;
    }
    setState(() {
      _status = 0;
    });
  }

  void _changeToHistory() {
    if (_status == 1) {
      return;
    }
    setState(() {
      _status = 1;
    });
  }

//  getListPerson() async {
//    var request = new Request();
//    var listPerson = await request.getFavourite().then();
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    post = Request.getFavourite();
    _futureBuilderFuture = _getData();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
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
                          icon: Icon(Icons.arrow_forward),
                          color: Colors.white,
                          iconSize: 36.0,
                          onPressed: () {
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
          Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: FutureBuilder(
                  builder: _buildFuture,
                  future: _futureBuilderFuture, // 用户定义的需要异步执行的代码，类型为Future<String>或者null的变量或函数
            ),
          )),
        ],
      ),
    );
  }

  Future _getData() async {
    var response = HttpUtils.get(
        'https://ar-business-card.eu-gb.cf.appdomain.cloud/HistoryList');
    return response;
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        print('还没有开始网络请求');
        return Text('还没有开始网络请求');
      case ConnectionState.active:
        print('active');
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        print('waiting');
        return Center(
          child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
        print("done");
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return _createListView(context, snapshot);
      default:
        return Text('还没有开始网络请求');
    }
  }

  Widget _createListView(BuildContext context, AsyncSnapshot snapshot) {
    var list = snapshot.data["HistoryList"];
    return ListView.separated(
      itemBuilder: (context, index) => _itemBuilder(context, index, list),
      itemCount: list.length + 1,
      separatorBuilder: (context, index) => Divider(
        height: 25,
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index, list) {
    if (index == list.length) {
      return Divider();
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
  Future<Null> _handleRefresh() async{
    setState(() {
      _futureBuilderFuture = _getData();
    });
  }
}
