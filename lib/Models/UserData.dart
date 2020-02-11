import 'dart:convert';

class UserData{
  static final PERFER_NOT_TO_SAY = 0;
  static final FEMALE = 1;
  static final MALE = 2;
  String _lastName;
  String _firstName;
  String _description;
  String _experience;
  String _education;
  String _profile;
  int _gender;
  String _userName;
  String _id;
  String _model;
  bool _isFavourite = false;
  UserData( this._id,this._firstName,this._lastName, this._profile,this._userName,{String description, String experience,
      String education,int gender,String model}){
    _gender=gender;
    _description=description;
    _experience=experience;
    _education=education;
    _model = model;
  }

  String get model => _model;

  set model(String value) {
    _model = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  int get gender => _gender;

  set gender(int value) {
    _gender = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }


  String get profile => _profile;

  set profile(String value) {
    _profile = value;
  }

  bool get isFavourite => _isFavourite;

  set isFavourite(bool value) {
    _isFavourite = value;
  }

  String get education => _education;

  set education(String value) {
    _education = value;
  }

  String get experience => _experience;

  set experience(String value) {
    _experience = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }

  String get lastName => _lastName;

  set lastName(String value) {
    _lastName = value;
  }
  String getJson(){
    Map<String,dynamic> map = {
      '_id':_id,
      'firstname':_firstName,
      'lastname':_lastName,
      'username':_userName,
      'description':_description,
      'experience':_experience,
      'education':_education,
      'gender':_gender,
      'profile':_profile,
      'model':_model
    };
    _profile = _profile??"";
    var json = JsonEncoder();
    return json.convert(map);
  }
  static UserData toUserData(String userJson){
    UserData user;
      var decoder = JsonDecoder();
      Map<String, dynamic> json;
      json = decoder.convert(userJson);
      user = UserData(
          json['_id'],json['firstname'], json['lastname'], json['profile']??"",json['username'],
          description: json['description'] ?? "",
          experience: json['experience'] ?? "",
          education: json['education'] ?? "",
          gender : json['gender']??0,
          model: json['model']??"",
      );
      user.isFavourite = json['isFav']??false;
    return user;
  }
}