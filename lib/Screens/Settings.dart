import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Models/ProfileTextEditor.dart';
class Settings extends StatefulWidget {
  Settings({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
  static final PERFER_NOT_TO_SAY = 0;
  static final FEMALE = 1;
  static final MALE = 2;
  leavePage() {
    Navigator.pop(context);
  }
  initController(){
    _descriptionController= TextEditingController();
    _workExperiencesController = TextEditingController();
    _educationController = TextEditingController();
  }
  TextEditingController _descriptionController;
  TextEditingController _educationController;
  double _height;
  double _width;
  String _firstName = "Henry";
  TextEditingController _workExperiencesController;
  int _sex = PERFER_NOT_TO_SAY;
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
          resizeToAvoidBottomPadding: false,
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
                      padding: EdgeInsets.only(top: 30, left: 65),
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
                                  width: _width * 0.4,
                                  child: AutoSizeText(
                                    '$_firstName $_lastName',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40
                                    ),
                                    minFontSize: 20,
                                    maxFontSize: 30,
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
                                          width: _width * 0.4,
                                          child:AutoSizeText(
                                            ''
                                                '$_id',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            minFontSize: 15,
                                            maxFontSize: 20,
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
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:40),
                      child:ProfileTextEditor(
                          Text(
                            'Gender',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white
                            ),
                          ),
                          ProfileTextEditor.DROPDOWN,
                          _descriptionController,
                          hint:'Tell us more about yourself',
                        dropContent: ["Perfer not to say","Female","Male"],
                        currentSelect: _sex==PERFER_NOT_TO_SAY? 'Perfer not to say' : _sex == FEMALE ? 'Female' : 'Male',
                        dropOnChange: (value){
                          if(value == 'Perfer not to say'){
                            _sex = PERFER_NOT_TO_SAY;
                          }else if(value == 'Female'){
                            _sex = FEMALE;
                          }else if(value == 'Male'){
                            _sex = MALE;
                          }
                          setState(() {

                          });
                        },
                      ) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:40),
                      child:ProfileTextEditor(
                          Text(
                            'One-Sentence Description',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white
                            ),
                          ),
                          ProfileTextEditor.TEXTBOX,
                          _descriptionController,
                          hint:'Tell us more about yourself'
                      ) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:40),
                      child:ProfileTextEditor(
                          Text(
                            'Work Experiences',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white
                            ),
                          ),
                          ProfileTextEditor.TEXTBOX,
                          _workExperiencesController,
                          hint:'Where do you currently work? How about 3 years ago?'
                      ) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:40),
                      child:ProfileTextEditor(
                          Text(
                            'Education',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white
                            ),
                          ),
                          ProfileTextEditor.TEXTBOX,
                          _educationController,
                          hint:'Where did you attend your uni and high school? How was your grade?'
                      ) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:25),
                      child:Opacity(
                        opacity: 0.38,
                        child: Text(
                          'You can download your QR code for printing on your physical business card by tap the button at the top right corner.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:25),
                      child:Opacity(
                        opacity: 0.38,
                        child: Text(
                          'Change your name and profile picture in your LinkedIn account.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:25),
                      child:FlatButton(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 61, 63, 83),
                              borderRadius:BorderRadius.all(const  Radius.circular(30.0)),
                          ),
                          width: 150,
                          height: 40,
                          child: Center(
                            child:Text(
                            'Open',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15
                            ),
                            )
                          ),
                        )
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:6,bottom: 80),
                      child: FlatButton(
                        child: Text(
                          'Logout LinkedIn',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: _bottomHeight,
                color: Color.fromARGB(255, 41, 43, 66),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 61, 63, 83),
                            borderRadius:BorderRadius.all(const  Radius.circular(30.0)),
                          ),
                          width: 150,
                          height: 40,
                          child: Center(
                              child:Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15
                                ),
                              )
                          ),
                        ),
                      onPressed: _showDialog,
                    ),
                    FlatButton(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 61, 63, 83),
                            borderRadius:BorderRadius.all(const  Radius.circular(30.0)),
                          ),
                          width: 150,
                          height: 40,
                          child: Center(
                              child:Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15
                                ),
                              )
                          ),
                        )
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        onWillPop: () async {
          bool leave = await _showDialog();
          return Future.value(leave);
        });
  }
  Future<bool> _showDialog() async{
    bool leave = false;
    await showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: new Text("Do you want to save you change?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Save"),
              onPressed:(){
                leave = true;
              }
            ),
            new FlatButton(
              child: new Text("Discard"),
              onPressed: (){
                leave = true;
              }
            ),
            new FlatButton(
              child: new Text("Cancel"),
                onPressed: (){
                  leave = false;
                }
            ),
          ],
        );
      }
    );
    print(leave);
    return leave;
  }
  contentOnSave(){
    return;
  }
  contentOnExit(){
    return;
  }
}
