import 'package:flutter_test/flutter_test.dart';
import 'package:tencent_cloud_api/common.dart';
import 'package:tencent_cloud_api/sign.dart';

void testSign() {
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