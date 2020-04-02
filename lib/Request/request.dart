import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_app/Models/Config.dart';
import 'package:flutter_app/Models/GlobalData.dart';
import 'package:http/http.dart' as http;

class HttpUtils {
  static Future<Response> get(url, {data, options, cancelToken, header}) async {
    if (options == null) {
      options = Options(headers: header);
    }
    Response response;
    try {
      response =
          await Dio().get(url, cancelToken: cancelToken, options: options);
//      print('get请求成功!response.data： ${response.data}');
      print('get request success!');
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('get request cancel' + e.message);
      }
      print('get request error：$e');
    }
    return response;
  }

  static Future<Response> post(url,
      {data, options, cancelToken, header}) async {
    if (options == null) {
      options = Options(headers: header);
    }
//    print('post request started! url：$url ,body: $data');
    Response response;
    try {
      response = await Dio().post(
        url,
        data: data,
        cancelToken: cancelToken,
        options: options,
      );
//      print('post request success!response.data：${response.data}');
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('post request cancel! ' + e.message);
      }
      print('post request error：$e');
    }
    return response;
  }
}

class RequestCards {
  static JsonEncoder jsonEncoder = JsonEncoder();
  static GlobalData globalData = GlobalData();
  static JsonDecoder jsonDecoder = JsonDecoder();
  static String encodeJson(Map<String, dynamic> map) {
    final result = jsonEncoder.convert(map);
    return result;
  }

  static Future<Response> favouriteAdd(id) async {
    final result = encodeJson({"userid": id});
    final response = await HttpUtils.post('${Config.baseURl}/favorite/add',
        data: result, header: {"Authorization": "Bearer ${globalData.token}"});
    return response;
  }

  static Future<Response> favouriteRemove(id) async {
    final result = encodeJson({"userid": id});
    final response = await HttpUtils.post('${Config.baseURl}/favorite/remove',
        data: result, header: {"Authorization": "Bearer ${globalData.token}"});
    return response;
  }

  static Future<Response> historyAdd(id) async {
    final result = encodeJson({"userid": id});
    final response = await HttpUtils.post('${Config.baseURl}/history/add',
        data: result, header: {"Authorization": "Bearer ${globalData.token}"});
    return response;
  }

  static Future<Response> historyRemove(id) async {
    final result = encodeJson({"userid": id});
    final response = await HttpUtils.post('${Config.baseURl}/history/remove',
        data: result, header: {"Authorization": "Bearer ${globalData.token}"});
    return response;
  }

  static Future<Response> getWatsonContent(id, name, content) async {
    final result = encodeJson(
        {"userid": id ?? "", "content": content, "senderUsername": name ?? ""});
    print(result);
    final response =
        await HttpUtils.post('${Config.baseURl}/chat', data: result);
    print(response.data);
    return response;
  }

  static Future<Response> getUserData(name) async {
    final response = await HttpUtils.post(
        '${Config.baseURl}/profile/get?username=$name',
        data: encodeJson({"_id": globalData.userData.id}));
    return response;
  }

//  static Future<http.Response> getUserDataByID(name) async {
//    final response = await http.post(
//        '${Config.baseURl}/profile/get?username=$name',
//        headers: {"Content-Type": "application/json"},
//        body: globalData.userData.id);
//    return response;
//  }

  static Future<Response> logOutAll() async {
    final response = await HttpUtils.post('${Config.baseURl}/user/logout-all',
        header: {"Authorization": "Bearer ${globalData.token}"});
    return response;
  }
}
