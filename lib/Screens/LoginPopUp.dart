import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPopUp extends StatefulWidget{
  @override
  State createState() => _LoginPopUp();

}

class _LoginPopUp extends State<LoginPopUp>{
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    double _width;
    double _height;
    _width = MediaQuery.of(context).size.width * 0.7;
    _height = MediaQuery.of(context).size.height * 0.4;
    return Container(
      width: _width,
      height: _height,
      child: Column(
        children: <Widget>[
          Container(
            height: _height*0.4,
            child: Row(
              children: <Widget>[
                AnimatedContainer(
                  width:_width*0.5,
                  duration: Duration(milliseconds: 500),
                  color: isLogin ? Colors.white : Colors.cyanAccent ,
                ),
                AnimatedContainer(
                  width:_width*0.5,
                  duration: Duration(milliseconds: 500),
                  color: isLogin ? Colors.cyanAccent:Colors.white ,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}