import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tencent_cloud_api/common.dart';
import 'package:tencent_cloud_api/soe/OralProcess.dart';
import 'package:tencent_cloud_api/soe/SoeClient.dart';

final _credential = Credential(Platform.environment['SOE_SECRET_ID'], Platform.environment['SOE_SECRET_KEY']);

void main() {
  var soeClient = SoeClient(_credential);

  test('initOralProcess', () async {
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var oralProcess = OralProcess(
      sessionId: 'sessionId$timestamp',
      refText: 'testSOE$timestamp',
      workMode: WorkMode.once,
      evalMode: EvalMode.word,
      scoreCoeff: 1.0,
    );

    var response = await soeClient.initOralProcess(oralProcess);
    expect(response, isNotNull); // TODO
  });
}