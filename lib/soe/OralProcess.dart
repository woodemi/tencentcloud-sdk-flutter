import 'package:meta/meta.dart';

import 'struct.dart';

class OralProcess {
  final String sessionId;
  final String refText;
  final WorkMode workMode;
  final EvalMode evalMode;
  final double scoreCoeff;

  /// Storage voice data if only [Boolean.yes]
  final Boolean storageMode;

  /// [ServerType.english] if missing
  final ServerType serverType;

  OralProcess({
    @required this.sessionId,
    @required this.refText,
    @required this.workMode,
    @required this.evalMode,
    @required this.scoreCoeff,
    this.storageMode,
    this.serverType,
  }): assert(sessionId?.isNotEmpty),
        assert(refText?.isNotEmpty),
        assert(workMode != null),
        assert(evalMode != null),
        assert(1.0 <= scoreCoeff && scoreCoeff <= 4.0);
}

class WorkMode extends Integer {
  static final stream = WorkMode._(0);
  static final once = WorkMode._(1);

  WorkMode._(int value): super(value);
}

class EvalMode extends Integer {
  static final word = EvalMode._(0);
  static final sentence = EvalMode._(1);
  static final paragraph = EvalMode._(2);
  static final free = EvalMode._(3);

  EvalMode._(int value): super(value);
}

class ServerType extends Integer {
  static final english = ServerType._(0);
  static final chinese = ServerType._(1);

  ServerType._(int value): super(value);
}