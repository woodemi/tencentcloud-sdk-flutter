import '../AbstractClient.dart';
import '../common.dart';
import 'OralProcess.dart';

class SoeClient extends AbstractClient {
  SoeClient(Credential credential) : super(
    endpoint: 'soe.tencentcloudapi.com',
    apiVersion: '2018-07-24',
    credential: credential,
  );

  Map<String, Object> _buildOralProcessParams(OralProcess oralProcess) {
    return {
      'SessionId': oralProcess.sessionId,
      'RefText': oralProcess.refText,
      'WorkMode': oralProcess.workMode,
      'EvalMode': oralProcess.evalMode,
      'ScoreCoeff': oralProcess.scoreCoeff,
      if (oralProcess.storageMode != null) 'StorageMode': oralProcess.storageMode,
      if (oralProcess.serverType != null) 'ServerType': oralProcess.serverType,
    };
  }

  Future<String> initOralProcess(OralProcess oralProcess) async {
    var action = 'InitOralProcess';
    var actionParams = _buildOralProcessParams(oralProcess);

    return (await postRequest(action, actionParams)).toString();
  }
}