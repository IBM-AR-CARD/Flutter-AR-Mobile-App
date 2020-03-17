import 'dart:convert';

class UserData{
  static final PERFER_NOT_TO_SAY = 0;
  static final FEMALE = 1;
  static final MALE = 2;
  String _lastName;
  String _firstName;
  String description;
  String experience;
  String education;
  String _profile;
  int gender;
  String _userName;
  String _id;
  String model;
  bool _isFavourite = false;
  String phoneNumber;
  String website;
  String email;

  UserData( this._id,this._firstName,this._lastName, this._profile,this._userName,{this.description, this.experience,
      this.education,this.gender,this.model,this.phoneNumber,this.website,this.email});


  String get id => _id;

  set id(String value) {
    _id = value;
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
      'description':description,
      'experience':experience,
      'education':education,
      'gender':gender,
      'profile':_profile,
      'model':model,
      'isFav':_isFavourite,
      "phone":phoneNumber,
      "website":website,
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
          phoneNumber:json['phone']??"",
          website: json['website']??"",
          email: json['email']??""
      );
      user.isFavourite = json['isFav']??false;
    return user;
  }
  static UserData mapToUserData(Map userMap){
    Map<String,dynamic>json = userMap;
    UserData user = UserData(
      json['_id'],json['firstname'], json['lastname'], json['profile']??"",json['username'],
      description: json['description'] ?? "",
      experience: json['experience'] ?? "",
      education: json['education'] ?? "",
      gender : json['gender']??0,
      model: json['model']??"",
      phoneNumber:json['phone']??"",
      website: json['website']??"",
      email: json['email']??""
    );
    user.isFavourite = json['isFav']??false;
    return user;
  }
}