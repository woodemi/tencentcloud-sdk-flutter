import 'dart:convert';

import '../AbstractClient.dart';
import '../common.dart';
import 'OralProcess.dart';
import 'VoiceFile.dart';
import 'struct.dart';

class SoeClient extends AbstractClient {
  SoeClient(Credential credential) : super(
    endpoint: 'soe.tencentcloudapi.com',
    apiVersion: '2018-07-2 4',
    credential: credential,
  );

  Map<String, Object> _buildOralProcessParams(OralProcess oralProcess) {
    return {
      'SessionId': oralProcess.sessionId,
      'RefText': oralProcess.refText,
      'WorkMode': oralProcess.workMode.value,
      'EvalMode': oralProcess.evalMode.value,
      'ScoreCoeff': oralProcess.scoreCoeff,
      if (oralProcess.storageMode != null) 'StorageMode': oralProcess.storageMode.value,
      if (oralProcess.serverType != null) 'ServerType': oralProcess.serverType.value,
    };
  }

  Future<String> initOralProcess(OralProcess oralProcess) async {
    var action = 'InitOralProcess';
    var actionParams = _buildOralProcessParams(oralProcess);

    return (await postRequest(action, actionParams)).toString();
  }

  Future<String> transmitOralProcessWithInit(OralProcess oralProcess, VoiceFile voiceFile) async {
    var actionParams = {
      ..._buildOralProcessParams(oralProcess),
      'SeqId': 1,
      'IsEnd': Boolean.yes.value,
      'VoiceFileType': voiceFile.voiceFileType.value,
      'VoiceEncodeType': voiceFile.voiceEncodeType.value,
      'UserVoiceData': base64.encode(voiceFile.userVoiceData),
    };

    return (await postRequestV3('TransmitOralProcessWithInit', actionParams)).toString();
  }
}