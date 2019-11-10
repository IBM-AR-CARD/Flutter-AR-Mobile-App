import 'dart:async';
import 'dart:convert';
class Request{
  static Future<void> getFavourite() async{
      var stringList = [
        {
          "name":"tom",
          "description":"student",
          "photo":"photo"
        },
        {
          "name":"henry",
          "description":"mentor",
          "photo":"photo"
        },
        {
          "name":"yoyo",
          "description":"student",
          "photo":"photo"
        },
        ];
      return stringList;
  }
}