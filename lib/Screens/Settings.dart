import 'dart:io';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_app/Models/Config.dart';
import 'package:flutter_app/Models/SaveQR.dart';
import 'package:flutter_app/Models/SlideRoute.dart';
import 'package:flutter_app/Screens/Login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swipedetector/swipedetector.dart';
import '../Models/ProfileTextEditor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/UserData.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import '../Models/GlobalData.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
class Settings extends StatefulWidget {
  static final PERFER_NOT_TO_SAY = 0;
  static final FEMALE = 1;
  static final MALE = 2;
  Settings({Key key, this.title}) : super(key: key);
  final String title;
  final GlobalData globalData = GlobalData();

  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> with WidgetsBindingObserver{
  final _descriptionController = TextEditingController();
  final _workExperiencesController = TextEditingController();
  final _educationController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String _firstName;
  int _gender = PERFER_NOT_TO_SAY;
  String _lastName;
  String _userName;
  UserData userData;
  String _model;
  File _imageFile;
  String _profile;
  GlobalData globalData;
  bool usedOutSide = false;
  final storedData = SharedPreferences.getInstance();
  bool hasChangedContent(){
    if(_firstName == _firstNameController.text && _lastName == _lastNameController.text && _gender == userData.gender && _descriptionController.text == userData.description && _educationController.text == userData.education && _workExperiencesController.text == userData.experience && userData.model == _model){
      return false;
    }
    return true;
  }
  initUserData() async {
    userData = widget.globalData.userData;
    _profile = (userData.profile)??"";
    _firstName = userData.firstName;
    _lastName = userData.lastName;
    _userName = userData.userName;
    _gender = userData.gender;
    _model = userData.model;


    _descriptionController.text = userData.description;
    _educationController.text = userData.education;
    _workExperiencesController.text = userData.experience;
    _firstNameController.text = userData.firstName;
    _lastNameController.text = userData.lastName;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _descriptionController.dispose();
    _workExperiencesController.dispose();
    _educationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
  }

  ProgressDialog pr;
  static final PERFER_NOT_TO_SAY = 0;
  static final FEMALE = 1;
  static final MALE = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initUserData();
    globalData = GlobalData();
  }
  Future<void> _pickImage()async{
    usedOutSide = true;
    File selected = await ImagePicker.pickImage(source: ImageSource.gallery);
    _imageFile = selected??_imageFile;
    await _cropImage();
  }


  Future<void> _cropImage()async{
    File cropped =  await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      aspectRatio:CropAspectRatio(ratioX: 1,ratioY: 1),

    );
    if(cropped != null) {
      _imageFile = cropped ?? _imageFile;
      await _upLoadImage(_imageFile);
    }
  }
  Future<File> CompressAndGetFile(File file) async {
    final path = join(
      (await getTemporaryDirectory()).path,
      '${DateTime.now().millisecondsSinceEpoch}_compress.jpg',
    );
      var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, path,
      quality: 88,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state)async {
    super.didChangeAppLifecycleState(state);
    print('state = $state');
    if(state == AppLifecycleState.inactive){
    }else if(state == AppLifecycleState.resumed){
      usedOutSide = true;
    }
  }
  _upLoadImage(File image)async{
    Dio dio = new Dio();
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
    final imageCompress = await CompressAndGetFile(image);
    FormData formData = FormData.fromMap(
      {
        "file": await MultipartFile.fromFile(imageCompress.absolute.path,filename: path.basename(imageCompress.path))
      }
    );
    try {
      final response = await dio.post(
        '${Config.baseURl}/upload',
        onSendProgress: (count, total) {

        },
        data: formData, //create a Stream<List<int>>
        options: Options(
          headers: {
            Headers.contentLengthHeader: imageCompress.length,
            // set content-length
            "Authorization": "Bearer ${widget.globalData.token}"
          },
        ),
      );

//      GlobalData().userData.profile = response.data['path'];
      _profile = response.data['path'];
      setState(() {

      });
    }catch(err){
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Network error"),
              content: new Text("please contact admin"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      print(err);
    }
  }

  Future<void> _takePicture()async{
    File result = await ImagePicker.pickImage(source: ImageSource.camera);
    if(result != null){
        _imageFile = result;
      await _cropImage();
    }
  }
  _onCamera()async{
    usedOutSide = true;
    await _takePicture();
    setState(() {});
  }
  showImageActionSheet()async{
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera_alt),
                    title: new Text('Camera'),
                    onTap:()async{
                      Navigator.pop(bc);
                      await _onCamera();
                    }
                ),
                new ListTile(
                  leading: new Icon(Icons.photo),
                  title: new Text('Gallery'),
                  onTap:()async{
                    Navigator.pop(bc);
                    await _pickImage();
                  },
                ),
              ],
            ),
          );
        }
    );

  }

  double _height;
  double _width;

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, isDismissible: false);
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    double _topHeight = _height * 0.25;
    double _middleHeight = _height * 0.68;
    double _bottomHeight = _height - _topHeight - _middleHeight;
    return new WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color.fromARGB(255, 31, 34, 52),
          body: SingleChildScrollView(
          child:SwipeDetector(
            child: Column(
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
                            onPressed: ()async{
                              if(await _onLeaving()){
                                Navigator.pop(context);
                              }
                            }
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
                      padding: EdgeInsets.only(top: 30, left: 50),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            child:FlatButton(
                              child: ClipRRect(

                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(40.0)),
                                child: FadeInImage(
                                  width: 60,
                                  height: 60,
                                  image:NetworkImage(_profile),
                                  placeholder: AssetImage(
                                      'assets/images/unknown-avatar.jpg'
                                  ),
                                ),
                              ),
                              onPressed: showImageActionSheet,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child:SizedBox(
                              width: _width * 0.4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: _width * 0.4,
                                    child: AutoSizeText(
                                      _firstName.toString() +
                                          " " +
                                          _lastName.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40),
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
                                          width: _width * 0.3,
                                          child: AutoSizeText(
                                            _userName??"null",
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
                            )
                          ),
                          FlatButton(
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.file_download,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  Text(
                                    'QR',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  )
                                ],
                              ),
                              onPressed: _showQR,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                color: Color.fromARGB(255, 41, 43, 66),
                height: _topHeight,
              ),
              Theme(
                data: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                child: Container(
                  height: _middleHeight,
                  width: _width * 0.88,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Opacity(
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
                        padding: EdgeInsets.only(top: 40),
                        child: ProfileTextEditor(
                            Text(
                              'First Name',
                              style: TextStyle(fontSize: 24, color: Colors.white),
                            ),
                            ProfileTextEditor.TEXTBOX,
                            _firstNameController,
                            hint: 'your first name'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: ProfileTextEditor(
                            Text(
                              'Last Name',
                              style: TextStyle(fontSize: 24, color: Colors.white),
                            ),
                            ProfileTextEditor.TEXTBOX,
                            _lastNameController,
                            hint: 'your Last name'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: ProfileTextEditor(
                          Text(
                            'Model',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                          ProfileTextEditor.DROPDOWN,
                          _descriptionController,
                          dropContent: [ "TestMale", "Luffy", "FitFemale", "Jiraiya", "YodaRigged", "BusinessMale", "BusinessFemale", "SmartMale", "SmartFemale" ],
                          currentSelect:_model,
                          dropOnChange: (value) {
                            _model=value;
                            setState(() {});
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: ProfileTextEditor(
                          Text(
                            'Gender',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                          ProfileTextEditor.DROPDOWN,
                          _descriptionController,
                          dropContent: ["Perfer not to say", "Female", "Male"],
                          currentSelect:
                          _gender == ProfileTextEditor.PERFER_NOT_TO_SAY
                              ? 'Perfer not to say'
                              : _gender == FEMALE ? 'Female' : 'Male',
                          dropOnChange: (value) {
                            if (value == 'Perfer not to say') {
                              _gender = PERFER_NOT_TO_SAY;
                            } else if (value == 'Female') {
                              _gender = FEMALE;
                            } else if (value == 'Male') {
                              _gender = MALE;
                            }
                            setState(() {});
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: ProfileTextEditor(
                            Text(
                              'One-Sentence Description',
                              style: TextStyle(fontSize: 24, color: Colors.white),
                            ),
                            ProfileTextEditor.TEXTBOX,
                            _descriptionController,
                            hint: 'Tell us more about yourself'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: ProfileTextEditor(
                            Text(
                              'Work Experiences',
                              style: TextStyle(fontSize: 24, color: Colors.white),
                            ),
                            ProfileTextEditor.TEXTBOX,
                            _workExperiencesController,
                            hint:
                            'Where do you currently work? How about 3 years ago?'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: ProfileTextEditor(
                            Text(
                              'Education',
                              style: TextStyle(fontSize: 24, color: Colors.white),
                            ),
                            ProfileTextEditor.TEXTBOX,
                            _educationController,
                            hint:
                            'Where did you attend your uni and high school? How was your grade?'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Opacity(
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
                        padding: EdgeInsets.only(top: 25),
                        child: Opacity(
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
                          padding: EdgeInsets.only(top: 25),
                          child: FlatButton(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 61, 63, 83),
                                  borderRadius:
                                  BorderRadius.all(const Radius.circular(30.0)),
                                ),
                                width: 150,
                                height: 40,
                                child: Center(
                                    child: Text(
                                      'Open',
                                      style: TextStyle(color: Colors.white, fontSize: 15),
                                    )),
                              ))),
                      Padding(
                        padding: EdgeInsets.only(top: 6, bottom: 80),
                        child: FlatButton(
                          onPressed: onLogOut,
                          child: Text(
                            'Logout LinkedIn',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      )
                    ],
                  ),
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
                          borderRadius:
                              BorderRadius.all(const Radius.circular(30.0)),
                        ),
                        width: 150,
                        height: 40,
                        child: Center(
                            child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )),
                      ),
                      onPressed: ()async{
                        if(await _onLeaving()){
                          Navigator.pop(context,usedOutSide);
                        }
                      },
                    ),
                    FlatButton(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 61, 63, 83),
                          borderRadius:
                              BorderRadius.all(const Radius.circular(30.0)),
                        ),
                        width: 150,
                        height: 40,
                        child: Center(
                            child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )),
                      ),
                      onPressed: () async{
                        await contentOnSave();
                        GlobalData().resumeControllerState();
                        Navigator.pop(context,usedOutSide);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
            onSwipeRight: ()async{
              if(await _onLeaving()){
                Navigator.pop(context,usedOutSide);
              }
            },
          ),
          ),
        ),
        onWillPop:()async{
          final result = await _onLeaving();
          if(result){
            if(!usedOutSide){
              globalData.resumeControllerState();
            }
            Navigator.pop(context,usedOutSide);
          }
          return false;
        }
    );
  }

  contentOnSave() async {
    if(!hasChangedContent() && _profile == userData.profile){
      return;
    }

    widget.globalData.userData = userData;
    userData.experience = _workExperiencesController.text;
    userData.gender = _gender;
    userData.education = _educationController.text;
    userData.description = _descriptionController.text;
    userData.model = _model;
    userData.firstName = _firstNameController.text;
    userData.lastName=_lastNameController.text;
    userData.profile = _profile;
    String userJson = userData.getJson();
    await storeValue(userJson);
    return;
  }

  storeValue(userJson) async {
    (await storedData).setString("UserData", userJson);
    pr.show();
    try{
      print('request');
      await http.post('${Config.baseURl}/profile/update', headers: {"Content-Type": "application/json","Authorization":"Bearer ${widget.globalData.token}"}, body: userJson).timeout(Duration(seconds: 5));
    }catch(err){
      print(err);
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Network Error"),
              content: new Text("please contact admin"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    pr.hide();
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }finally{
      print('final');
      pr.hide();
    }
  }

  contentOnExit() {
    return;
  }
  onLogOut()async{
    if(await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want log out?'),
        actions: <Widget>[
          new FlatButton(
              child: new Text("Log out"),
              onPressed: () {
                contentOnExit();
                Navigator.of(context).pop(true);
              }),
          new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              }),
        ],
      ),
    ) ??
        false){
      globalData.clearData();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('E-MAIL','');
      await preferences.setString('PASSWORD', '');
      await  preferences.setBool('hasLogin',false);
      globalData.hasLogin = false;
      globalData.wantLogin = true;
      Navigator.pushReplacement(context, FadeRoute(page: Login()));
    }
  }

  Future<bool> _onLeaving() async {
    if(!hasChangedContent()){
      return true;
    }
    final bool =
        await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to keep you change?'),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Discard"),
                  onPressed: () {
                    contentOnExit();
                    Navigator.of(context).pop(true);
                  }),
              new FlatButton(
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  }),
            ],
          ),
        ) ??
        false;
    if(bool){
      await GlobalData.globalData.resumeControllerState();
    }
    return bool;
  }
  _showQR(){
    SaveQR qr = SaveQR('${Config.baseURl}/profile/get?username=${widget.globalData.userData.userName}');
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              width: 250,
              height: 350,
              child:Column(
              children: <Widget>[
                qr,
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 61, 63, 83),
                          borderRadius:
                          BorderRadius.all(const Radius.circular(30.0)),
                        ),
                        width: 100,
                        height: 40,
                        child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            )),
                      ),
                      onPressed: ()async{
                        Navigator.pop(context,usedOutSide);
                      },
                    ),
                    FlatButton(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 61, 63, 83),
                          borderRadius:
                          BorderRadius.all(const Radius.circular(30.0)),
                        ),
                        width: 100,
                        height: 40,
                        child: Center(
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            )),
                      ),
                      onPressed: () async{
                        await qr.savePng();
                        Navigator.pop(context,usedOutSide);
                      },
                    )
                  ],
                )
              ],
            ),
            )
          );
        }
    );
  }
}
