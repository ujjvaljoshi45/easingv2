import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ApiManager {
  static ApiManager instance = ApiManager._init();
  late Dio dio;
  ApiManager._init() {
    dio = Dio();
    if (!kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        error: true,
        request: false,
        requestBody: false,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        logPrint: (object) => Logger(printer: PrettyPrinter(colors: true)).d(object),
      ));
    }
  }

  Future<Response> post(String url, Map<String, dynamic> data,
      {Map<String, dynamic>? parameters, Options? options}) async {
    try {
      return await dio.post(url, options: options, queryParameters: parameters, data: data);
    } on DioException catch (e) {
      return e.response ?? Response(requestOptions: RequestOptions());
    }
  }


  Future<Response> get(String url, [Map<String, dynamic>? parameters, Options? options]) async {
    try {
      return await dio.get(
        url,
        options: options,
      );
    } on DioException catch (e) {
      return e.response ?? Response(requestOptions: RequestOptions(), data: {'error': e});
    }
  }
}
