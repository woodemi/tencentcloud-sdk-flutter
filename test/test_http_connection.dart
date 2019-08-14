import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tencent_cloud_api/HttpConnection.dart';

void testHttpConnection() {
  test('post request with plaintext', () async {
    var nextInt = Random().nextInt(1<<16);
    var response = await HttpConnection().post('https://postman-echo.com/post', data: '$nextInt');
    var responseBody = response.data;
    expect(responseBody['data'], '$nextInt');
  });

  test('post request with custom content-type', () async {
    var nextInt = Random().nextInt(1<<16);
    var response = await HttpConnection().post('https://postman-echo.com/post', data: '$nextInt', headers: {
      HttpHeaders.contentTypeHeader: 'application/$nextInt',
    });
    var responseBody = response.data;
    expect(responseBody['data'], '$nextInt');
    expect(responseBody['headers'][HttpHeaders.contentTypeHeader], 'application/$nextInt');
  });
}