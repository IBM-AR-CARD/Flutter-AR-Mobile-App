import 'package:flutter/material.dart';
class ProfileTextEditor extends StatefulWidget {
  static final PERFER_NOT_TO_SAY = 0;
  static final FEMALE = 1;
  static final MALE = 2;
  static final int DROPDOWN = 0;
  static final int TEXTBOX = 1;
  Widget _title;
  int _type;
  TextEditingController _controller;
  List<String> _dropContent;
  String _hint;
  String _text;
  Function _dropOnChange;
  String _currentSelect;
  String title;
  ProfileTextEditor(this._title,this._type,this._controller,
      {Key key,
        this.title,
        String text,
        String hint,
        List<String> dropContent,
        Function dropOnChange,
        String currentSelect,
        int gender}): super(key: key) {
    _hint = hint;
    _text = text;
    _dropContent = dropContent;
    _dropOnChange = dropOnChange;
    _currentSelect = currentSelect;
  }
  @override
  _ProfileTextEditor createState() {
    return new _ProfileTextEditor();
  }
}
class _ProfileTextEditor extends State<ProfileTextEditor> {
  TextEditingController _controller;
  static final PERFER_NOT_TO_SAY = 0;
  static final FEMALE = 1;
  static final MALE = 2;
  static final int DROPDOWN = 0;
  static final int TEXTBOX = 1;

  @override
  void initState(){
    super.initState();
    _controller = widget._controller;
    setState(() {});
  }
  Widget build(context) {
    int maxLines = 4;
    if(widget._hint != null && (widget._hint == 'your first name' || widget._hint == 'your Last name')){
      maxLines = 1;
    }
    Widget box;
    if (widget._type == TEXTBOX) {
      box = new Padding(
        padding: EdgeInsets.only(top: 30),
        child: new TextField(
          style: new TextStyle(color: Colors.white),
          maxLines: maxLines,
//          expands: true,
          controller: _controller,
          decoration: new InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 61, 63, 83),
              hintText: widget._hint,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.3),
              ),
              labelStyle: new TextStyle(color: const Color.fromARGB(255, 0, 196, 225))),
        ),
      );
    } else if (widget._type == DROPDOWN) {
      box = Padding(
          padding: EdgeInsets.only(top: 30),
          child:ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft:  const  Radius.circular(4.0),
                  topRight: const  Radius.circular(4.0))
                    )
                ),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 61, 63, 83),
              border: Border(
                bottom: BorderSide(
                  color: Colors.black
                )
              ),
            ),
            height:50,
            width: MediaQuery.of(context).size.width,
            child: new Theme(
              data: new ThemeData(
                canvasColor: Color.fromARGB(255, 41, 43, 66),
                  primaryColor: Colors.black,
                  accentColor: Colors.black,
                  hintColor: Colors.black,
              ),
              child:Listener(
                onPointerDown: (_) => FocusScope.of(context).unfocus(),
                child:DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: widget._currentSelect,
                  isExpanded: true,
                  items: widget._dropContent.map((String val) {
                    return new DropdownMenuItem<String>(
                      value: val,
                      child:Padding(
                        padding: EdgeInsets.only(left:15),
                        child: new Text(
                          val,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    );
                  }).toList(),
                  onChanged: widget._dropOnChange,
                ),
                ),
              ),
            ),
          ),
          ));

    }
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[widget._title, box],
    );
  }
}
