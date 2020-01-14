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
  int _gender;
  UserData( this._firstName,this._lastName, this._gender,{String description, String experience,
      String education}){
    _description=description;
    _experience=experience;
    _education=education;
  }

  int get gender => _gender;

  set gender(int value) {
    _gender = value;
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
      'firstname':_firstName,
      'lastname':_lastName,
      'description':_description,
      'experience':_experience,
      'education':_education,
      'gender':_gender
    };
    var json = JsonEncoder();
    return json.convert(map);
  }
  static UserData toUserData(String userJson){
    UserData user;
    if(userJson == null || userJson==""){
      user = UserData("", "", 0);
    }else {
      var decoder = JsonDecoder();
      Map<String, dynamic> json;
      json = decoder.convert(userJson);
//    Map<String,dynamic> json = decoder.convert(userJson);
      user = UserData(
          json['firstName'] ?? "", json['lastname'] ?? "", json['gender'] ?? 0,
          description: json['description'] ?? "",
          experience: json['experience'] ?? "",
          education: json['education'] ?? "");
    }
    return user;
  }
}