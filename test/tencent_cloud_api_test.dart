import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tencent_cloud_api/HttpConnection.dart';

import 'test_cloud_api.dart';
import 'test_sign.dart';

void main() {
  test('sign a request', testSign);
  
  test('post request with plaintext', () async {
    var nextInt = Random().nextInt(1<<16);
    var response = await HttpConnection().post('https://postman-echo.com/post', data: '$nextInt');
    var responseBody = response.data;
    expect(responseBody['data'], '$nextInt');
  });

  test('invoke cloud api', testCloudApi, skip: 'TODO: Read params from environment');
}
