import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

import 'common.dart';

class Signer {
  final Credential credential;

  /// Missing indicates [SignatureMethod.HmacSHA1]
  final SignatureMethod signatureMethod;

  Signer(this.credential, [this.signatureMethod])
      : assert(credential != null);

  Map<String, Object> sign(String uriPrefix, Map<String, Object> plainParams) {
    var safeParams = {
      ...plainParams,
      ..._buildSecretInfo(),
    };

    var paramPairs = safeParams.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    var queryString = paramPairs.map((e) => '${e.key}=${e.value}').join('&');

    if (signatureMethod == SignatureMethod.HmacSHA256) {
      throw UnimplementedError('TODO');
    }
    var signature = _computeHmacSha1(credential.secretKey, '$uriPrefix?$queryString');
    return {
      ...safeParams,
      'Signature': signature
    };
  }

  Map<String, Object> _buildSecretInfo() {
    return {
      if (signatureMethod != null) 'SignatureMethod': signatureMethod.name,
      'SecretId': credential.secretId,
      if (credential.token?.isNotEmpty == true) 'Token': credential.token,
      'Timestamp': getTimestamp(),
      'Nonce': getNonce(),
    };
  }

  @visibleForTesting
  int getNonce() => Random().nextInt(1<<16);

  @visibleForTesting
  int getTimestamp() => DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;

  String _computeHmacSha1(String secretKey, String plaintext) {
    var digest = Hmac(sha1, utf8.encode(secretKey)).convert(utf8.encode(plaintext));
    return base64.encode(digest.bytes);
  }
}