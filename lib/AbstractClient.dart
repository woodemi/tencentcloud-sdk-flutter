import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

import 'HttpConnection.dart';
import 'common.dart';
import 'sign.dart';

const clientAgent = 'SDK_FLUTTER_3.0.0';

@visibleForTesting
class AbstractClient {
  // ---------------- Field ----------------

  final String region;

  final String endpoint;

  final String path = '/';

  final String apiVersion;

  AbstractClient({
    this.region,
    @required this.endpoint,
    @required this.apiVersion,
    @required Credential credential,
    SignatureMethod signatureMethod,
  }): this.signer = Signer(credential, signatureMethod),
      this.signerV3 = SignerV3(credential, endpoint.split('.')[0]);

  // ---------------- Helper ----------------

  final Signer signer;

  final SignerV3 signerV3;

  final httpConnection = HttpConnection();

  // ---------------- Property ----------------

  Map<String, String> get statisticsInfo => {
    if (region?.isNotEmpty == true) 'Region': '',
    'RequestClient': clientAgent,
  };

  // ---------------- Method ----------------

  Future<dynamic> postRequest(String action, Map<String, Object> actionParams) async {
    var plainParams = {
      'Version': apiVersion,
      'Action': action,
      ...actionParams,
      ...statisticsInfo,
    };
    var signedParams = signer.sign('POST$endpoint$path', plainParams);
    var encodedQueryString = signedParams.entries.map((e) {
      return '${e.key}=${Uri.encodeFull(e.value.toString())}';
    }).join('&');

    // TODO Handle exception
    var response = await httpConnection.post('https://$endpoint$path', data: encodedQueryString);
    return response.data;
  }

  /// Debug with [SignerV3.unsignedPayload]
  Future<dynamic> postRequestV3(String action, Map<String, Object> actionParams) async {
    var payload = json.encode(actionParams);

    var uriPrefix = ['POST', path, ''/*CanonicalQueryString*/,].join('\n');
    var plainHeaders = {
      HttpHeaders.hostHeader: endpoint,
      HttpHeaders.contentTypeHeader: ContentType.json.value,
    };
    var signedHeaders = signerV3.sign(uriPrefix, plainHeaders, payload);

    var headers = {
      'X-TC-Version': apiVersion,
      'X-TC-Action': action,
      ...signedHeaders,
    };

    // TODO Handle exception
    var response = await httpConnection.post('https://$endpoint$path', data: payload, headers: headers);
    return response.data;
  }
}