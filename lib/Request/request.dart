import 'package:dio/dio.dart';
class HttpUtils {
  static get(url, {data, options, cancelToken}) async {
    print('get request started! url：$url ,body: $data');
    Response response;
    try {
      response = await Dio().get(
        url,
        cancelToken: cancelToken,
      );
      //print('get请求成功!response.data： ${response.data}');
      print('get request success!');
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('get request cancel' + e.message);
      }
      print('get request error：$e');
    }
    return response.data;
  }

  static post(url, {data, options, cancelToken}) async {
    print('post request started! url：$url ,body: $data');
    Response response;
    try {
      response = await Dio().post(
        url,
        data: data,
        cancelToken: cancelToken,
      );
      print('post request success!response.data：${response.data}');
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('post request cancel! ' + e.message);
      }
      print('post request error：$e');
    }
    return response.data;
  }
}
