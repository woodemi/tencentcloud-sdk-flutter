import 'dart:typed_data';

class VoiceFile {
  final VoiceFileType voiceFileType;
  final VoiceEncodeType voiceEncodeType;
  final Uint8List userVoiceData;

  VoiceFile(this.voiceFileType, this.voiceEncodeType, this.userVoiceData);
}

class VoiceFileType {
  static final raw = VoiceFileType._(1);
  static final wav = VoiceFileType._(2);
  static final mp3 = VoiceFileType._(3);

  VoiceFileType._(this.value);

  final int value;
}

class VoiceEncodeType {
  static final pcm = VoiceEncodeType._(1);

  VoiceEncodeType._(this.value);

  final int value;
}