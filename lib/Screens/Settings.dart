import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'Models/ProfileTetEditor.dart';
class Settings extends StatefulWidget {
  Settings({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
  leavePage() {
    Navigator.pop(context);
  }

  double _height;
  double _width;
  String _firstName = "Henry";
  String _lastName = "Zhang";
  String _id = 'henry-zhang-9802';
  String _avatar =
      'https://media-exp2.licdn.com/dms/image/C5603AQEmBdyItPLjhQ/profile-displayphoto-shrink_200_200/0?e=1584576000&v=beta&t=W0OySxBMtrnGe5WBO9y0L93rK6N7vIUeyME9PxKG9go';
  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    double _topHeight = _height * 0.25;
    double _middleHeight = _height * 0.68;
    double _bottomHeight = _height - _topHeight - _middleHeight;
    return new WillPopScope(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 31, 34, 52),
          body: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 30, left: 20),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            color: Colors.white,
                            iconSize: 30,
                            onPressed: leavePage,
                          ),
                          Text(
                            'Your Profile',
                            style: TextStyle(
                                fontSize: 36,
                                fontFamily: "IBM Plex Sans",
                                color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30, left: 20),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: new BorderRadius.all(
                                const Radius.circular(40.0)),
                            child: Image.network(
                              _avatar,
                              width: 70,
                              height: 70,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: _width * 0.6,
                                  child: AutoSizeText(
                                    '$_firstName $_lastName',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40
                                    ),
                                    minFontSize: 20,
                                    maxFontSize: 40,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                  Row(
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        'assets/images/small_linkdin_logo.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: SizedBox(
                                          width: _width * 0.55,
                                          child:AutoSizeText(
                                            '@$_id',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            minFontSize: 15,
                                            maxFontSize: 30,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ),
                                      )
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Icon(
                                Icons.file_download,
                                color: Colors.white,
                                size: 40,
                              ),
                              Text(
                                'QR',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                color: Color.fromARGB(255, 41, 43, 66),
                height: _topHeight,
              ),
              Container(
                height:_middleHeight,
                width: _width*0.88,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top:25),
                      child:Opacity(
                        opacity: 0.38,
                        child: Text(
                          'Write down the information you want other people to know about you, choose your 3D avatar, customise your own AR business card below!  ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:25),
                        child: Text(
                          'Gender',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                    )



                  ],
                ),
              ),
              Container(
                height: _bottomHeight,
                color: Color.fromARGB(255, 41, 43, 66),
              ),
            ],
          ),
        ),
        onWillPop: () async {
          return true;
        });
  }
}
