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
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
              child: new ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return new Center(
                        child:Text("abcc")
                    );
                  }))
        ],
      ),
    );
  }
}

//  Widget getList(list){
//    return ListView.builder(
//      itemCount: list.length,
//        itemBuilder: (context,index){
//          return Container(
//            color: Color.fromARGB(255, 74, 79, 100),
//            width: 330,
//            height: 80,
//          );
//        }
//    );
//  }
//}
