import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tencent_cloud_api/common.dart';
import 'package:tencent_cloud_api/sign.dart';

void testSign() {
  test('sign ${SignatureMethod.HmacSHA1}', () {
    var signer = TestSigner(Credential('AKIDz8krbsJ5yKBZQpn74WFkmLPx3EXAMPLE', 'Gu5t9xGARNpq86cd98joQYCN3EXAMPLE'));
    signer.timestamp = 1465185768;
    signer.nonce = 11886;

    var plainParams = {
      'Action': 'DescribeInstances',
      'Region': 'ap-guangzhou',
      'InstanceIds.0': 'ins-09dx96dg',
      'Offset': 0,
      'Limit': 20,
      'Version': '2017-03-12',
    };

    var uriPrefix = 'GETcvm.tencentcloudapi.com/';
    var signedParams = signer.sign(uriPrefix, plainParams);
    expect(signedParams['Signature'], 'EliP9YW3pW28FpsEdkXt/+WcGeI=');
  });

  test('sign ${SignatureMethod.HmacSHA256}', () {
    // TODO
  });

  test('sign ${SignatureMethod.Tc3HmacSHA256}', () {
    var testSignerV3 = TestSignerV3(Credential('AKIDz8krbsJ5yKBZQpn74WFkmLPx3EXAMPLE', 'Gu5t9xGARNpq86cd98joQYCN3EXAMPLE'), 'cvm');
    testSignerV3.timestamp = 1551113065;

    var payload = '{"Limit": 1, "Filters": [{"Values": ["\\u672a\\u547d\\u540d"], "Name": "instance-name"}]}';

    var uriPrefix = ['POST', '/', ''/*CanonicalQueryString*/,].join('\n');
    var plainHeaders = {
      HttpHeaders.hostHeader: 'cvm.tencentcloudapi.com',
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    };
    var signedHeaders = testSignerV3.sign(uriPrefix, plainHeaders, payload);
    expect(signedHeaders['Authorization'], 'TC3-HMAC-SHA256 Credential=AKIDz8krbsJ5yKBZQpn74WFkmLPx3EXAMPLE/2019-02-25/cvm/tc3_request, SignedHeaders=content-type;host, Signature=72e494ea809ad7a8c8f7a4507b9bddcbaa8e581f516e8da2f66e2c5a96525168');
  });
}

class TestSigner extends Signer {
  TestSigner(Credential credential, [SignatureMethod signatureMethod]): super(credential, signatureMethod);

  int nonce;

  @override
  int getNonce() => nonce;

  int timestamp;

  @override
  int getTimestamp() => timestamp;
}

class TestSignerV3 extends SignerV3 {
  TestSignerV3(Credential credential, String service) : super(credential, service);

  int timestamp;

  @override
  int getTimestamp() => timestamp;
}