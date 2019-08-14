import 'package:flutter_test/flutter_test.dart';
import 'package:tencent_cloud_api/AbstractClient.dart';
import 'package:tencent_cloud_api/common.dart';

void testCloudApi() {
  test('post requet api', () async {
    var region = null;
    var endpoint = '';
    var apiVersion = '';
    var credential = Credential('', '');
    var action = '';
    var actionParams = {};

    var client = AbstractClient(
      region: region,
      endpoint: endpoint,
      apiVersion: apiVersion,
      credential: credential,
    );

    var response = await client.postRequest(action, actionParams);
    expect(response, isNotNull);
  });

  test('post requet v3 api', () async {
    var region = null;
    var endpoint = '';
    var apiVersion = '';
    var credential = Credential('', '');
    var action = '';
    var actionParams = {};

    var client = AbstractClient(
      region: region,
      endpoint: endpoint,
      apiVersion: apiVersion,
      credential: credential,
    );

    var response = await client.postRequestV3(action, actionParams);
    expect(response, isNotNull);
  });
}