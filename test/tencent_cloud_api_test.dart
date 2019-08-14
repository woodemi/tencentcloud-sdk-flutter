import 'package:flutter_test/flutter_test.dart';

import 'test_cloud_api.dart';
import 'test_http_connection.dart';
import 'test_sign.dart';

void main() {
  group('test sign', testSign);
  
  group('test http connection', testHttpConnection);

  test('invoke cloud api', testCloudApi, skip: 'TODO: Read params from environment');
}
