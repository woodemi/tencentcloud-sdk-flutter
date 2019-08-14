import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tencent_cloud_api/common.dart';
import 'package:tencent_cloud_api/soe/OralProcess.dart';
import 'package:tencent_cloud_api/soe/SoeClient.dart';
import 'package:tencent_cloud_api/soe/VoiceFile.dart';

import '../utils.dart';

final _credential = Credential(Platform.environment['SOE_SECRET_ID'], Platform.environment['SOE_SECRET_KEY']);

void main() {
  var soeClient = SoeClient(_credential);

  test('initOralProcess', () async {
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var oralProcess = OralProcess(
      sessionId: 'initOralProcess$timestamp',
      refText: 'testSOE$timestamp',
      workMode: WorkMode.once,
      evalMode: EvalMode.word,
      scoreCoeff: 1.0,
    );

    var response = await soeClient.initOralProcess(oralProcess);
    expect(response, isNotNull); // TODO
  });

  test('transmitOralProcessWithInit', () async {
    File file = await findFile('assets/soe/voice_data.json');
    String fileContent = await file.readAsString();
    var voiceDataBase64 = json.decode(fileContent)['UserVoiceData'];
    var voiceData = stripedBase64.decode(voiceDataBase64);

    var secondsSinceEpoch = DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;
    var sessionId = 'transmitOralProcessWithInit$secondsSinceEpoch';
    var oralProcess = OralProcess(
      sessionId: sessionId,
      refText: 'hello',
      workMode: WorkMode.once,
      evalMode: EvalMode.word,
      scoreCoeff: 1.0,
    );
    var response = await soeClient.transmitOralProcessWithInit(oralProcess, VoiceFile(VoiceFileType.mp3, VoiceEncodeType.pcm, voiceData));
    expect(response, isNotNull); // TODO
  });
}

// FIXME https://stackoverflow.com/a/57086750
Future<File> findFile(String path) async => await File(path).exists() ? File(path) : File('../$path');
