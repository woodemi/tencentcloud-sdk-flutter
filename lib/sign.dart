import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
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

class SignerV3 {
  final Credential credential;

  final signatureMethod = SignatureMethod.Tc3HmacSHA256;

  final String service;

  final bool ignorePayload;

  SignerV3(this.credential, this.service, [this.ignorePayload = false])
      : assert(credential != null), assert(service != null);

  static const unsignedPayload = 'UNSIGNED-PAYLOAD';

  static final dateFormat = DateFormat('yyyy-MM-dd');

  ///  If [ignorePayload] is true, [unsignedPayload] is used instead of [payload]
  Map<String, Object> sign(String uriPrefix, Map<String, String> plainHeaders, String payload) {
    assert(plainHeaders.containsKey(HttpHeaders.hostHeader));
    assert(plainHeaders.containsKey(HttpHeaders.contentTypeHeader));

    var headerPairs = plainHeaders.entries
        .map((e) => MapEntry(e.key.toLowerCase().trim(), e.value.trim()))
        .toList()..sort((a, b) => a.key.compareTo(b.key));
    var canonicalHeaders = headerPairs.map((e) => '${e.key}:${e.value}').join('\n') + '\n';
    var signedHeaders = headerPairs.map((e) => e.key).toList().join(';');
    var canonicalRequest = [
      uriPrefix,
      canonicalHeaders,
      signedHeaders,
      _computeSha256(ignorePayload ? unsignedPayload : payload), // HashedRequestPayload
    ].join('\n');
    var hashedCanonicalRequest = _computeSha256(canonicalRequest);

    var secondsSinceEpoch = getTimestamp();
    var date = dateFormat.format(DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * Duration.millisecondsPerSecond).toUtc());
    var credentials = [date, service, 'tc3_request'];
    var credentialScope = credentials.join('/');
    var stringToSign = [
      signatureMethod.name,
      secondsSinceEpoch, // RequestTimestamp
      credentialScope,
      hashedCanonicalRequest,
    ].join('\n');

    String signature = _signWithScope(credentials, stringToSign);

    var authInfo = [
      'Credential=${credential.secretId}/$credentialScope',
      'SignedHeaders=$signedHeaders',
      'Signature=$signature',
    ].join(', ');

    return {
      ...plainHeaders,
      'Authorization': '${signatureMethod.name} $authInfo',
      if (ignorePayload) 'X-TC-Content-SHA256': unsignedPayload,
      'X-TC-Timestamp': secondsSinceEpoch,
    };
  }

  @visibleForTesting
  int getTimestamp() => DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;

  String _signWithScope(List<String> credentials, String stringToSign) {
    var initialKey = utf8.encode('TC3${credential.secretKey}');
    var secretSigning = credentials.fold(initialKey, (lastKey, credential) {
      return _computeHmacSha256(lastKey, credential);
    });
    return hex.encode(_computeHmacSha256(secretSigning, stringToSign));
  }

  String _computeSha256(String plaintext) => sha256.convert(utf8.encode(plaintext)).toString();

  List<int> _computeHmacSha256(List<int> key, String plaintext) => Hmac(sha256, key).convert(utf8.encode(plaintext)).bytes;
}