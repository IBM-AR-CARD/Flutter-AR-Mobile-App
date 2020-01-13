import 'package:flutter/material.dart';
class ProfileTextEditor extends StatelessWidget {
  static final int DROPDOWN = 0;
  static final int TEXTBOX = 1;
  final String _title;
  final int _type;
  final TextEditingController _controller;
  String hint;
  String text;
  ProfileTextEditor(this._title, this._type,this._controller,{String text,String hint});
  Widget build(context){
    Widget box;
    if(_type == TEXTBOX){
      box = new TextField(
        controller: this._controller,
        decoration: new InputDecoration(
            hintText: hint,
            labelStyle: new TextStyle(
                color: const Color(0xFF424242)
            )
        ),
      );
      if(text != null)
      _controller.text = text;
    }
    return new Column(
      children: <Widget>[
        Text(
          '$_title',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        box
      ],
    );
  }
}