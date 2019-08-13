import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 127.0.0.1:80
String debugProxy;

class HttpConnection {
  final dio = Dio();

  HttpConnection() {
    if (kReleaseMode || debugProxy == null) return;

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.findProxy = (uri) => 'PROXY $debugProxy';
      client.badCertificateCallback = (cert, host, port) => true;
    };
  }

  Future<Response<T>> post<T>(
    String path, {
    String data,
  }) => dio.post(path, data: data);
}