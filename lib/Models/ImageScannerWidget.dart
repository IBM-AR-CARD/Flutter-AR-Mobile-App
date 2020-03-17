import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ImageScannerAnimation extends AnimatedWidget {
  final bool stopped;
  final double width;
  final Color colorGreen = Color(0xAA32CD32);
  ImageScannerAnimation(this.stopped, this.width,
      {Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final Animation<double> animation = listenable;
    final scorePosition = (animation.value * screenHeight*0.45) + screenHeight * 0.2;
    Color displayColor = colorGreen;
    if(animation.value < 0.3){
      displayColor = colorGreen.withOpacity(animation.value*2);
    }else if (animation.value > 0.7){
      displayColor = colorGreen.withOpacity((1- animation.value)*2);
    }
    Color color1 = displayColor;
    Color color2 = Color(0x0032CD32);
    BorderRadius radius = BorderRadius.only(topLeft: Radius.elliptical(width/2,80),topRight:  Radius.elliptical(width/2,80.0),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30));
    if (animation.status == AnimationStatus.reverse) {
      radius = BorderRadius.only(bottomLeft: Radius.elliptical(width/2,80),bottomRight:  Radius.elliptical(width/2,80.0),topLeft: Radius.circular(30),topRight: Radius.circular(30));
      color1 = Color(0x0032CD32);
      color2 = displayColor;
    }
    return new Positioned(
        bottom: screenHeight - scorePosition,
        left: (screenWidth - width) /2,
        child: new Opacity(
            opacity: (stopped) ? 0.0 : 1.0,
            child: Container(
              height: 40.0,
              width: width,
              decoration: new BoxDecoration(
//                  border: Border.all(color: Colors.blue, width: 0.0),
                  borderRadius: radius,
                  gradient: new LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.1, 0.9],
                    colors: [color1, color2],
                  )),
            )));
  }
}