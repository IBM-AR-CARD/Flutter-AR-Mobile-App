import 'package:flutter/cupertino.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
class SaveQR extends StatelessWidget{
  String _data;
  Widget _qrImage;
  SaveQR(this._data);
  GlobalKey globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        key: globalKey,
        child:Container(
      height: 250,
      width: 250,
      color:Colors.white,
      child:  QrImage(
        data: _data,
        size: 250,
        gapless: true,
      ),
    )
    );
  }

  getQR() {
    return _qrImage;
  }
  Future<void> savePng() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      final directory = Directory('/storage/emulated/0/ARBusiniessCard');
      if (!directory.existsSync())
        directory.create();
      print(directory);
      final imageName = DateTime.now().toIso8601String();
      final file = await new File('${directory.path}/$imageName.png').create();
      await file.writeAsBytes(pngBytes);
      Fluttertoast.showToast(
          msg: 'image $imageName.png stored in ${directory.path}/',
          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0
      );
    } catch(e) {
      print(e.toString());
      Fluttertoast.showToast(
          msg: 'image stored fail',
          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0
      );
    }
  }
}