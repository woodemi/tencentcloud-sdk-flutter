class Credential {
  final String secretId;
  final String secretKey;
  final String token;

  Credential(this.secretId, this.secretKey, [this.token])
      : assert(secretId != null),
        assert(secretKey != null);
}

class SignatureMethod {
  static final HmacSHA1 = SignatureMethod._('HmacSHA1');
  static final HmacSHA256 = SignatureMethod._('HmacSHA256');
  static final Tc3HmacSHA256 = SignatureMethod._('TC3-HMAC-SHA256');

  final String name;

  SignatureMethod._(this.name);
}
