import 'package:dio/dio.dart';
class HttpUtils {
  static get(url, {data, options, cancelToken,header}) async {
    Options options = Options(headers: header);
    print('get request started! url：$url ,body: $data');
    Response response;
    try {
      response = await Dio().get(
        url,
        cancelToken: cancelToken,
        options: options
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

  static post(url, {data, options, cancelToken,header}) async {
    Options options = Options(headers: header);
    print('post request started! url：$url ,body: $data');
    Response response;
    try {
      response = await Dio().post(
        url,
        data: data,
        cancelToken: cancelToken,
        options: options
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
