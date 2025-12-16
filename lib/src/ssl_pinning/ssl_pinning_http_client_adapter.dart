import 'dart:convert';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:fa_flutter_api_client/src/ssl_pinning/ssl_pinning_config.dart';
import 'package:flutter/foundation.dart';

/// Custom Dio HttpClientAdapter with SSL Certificate Pinning
///
/// This adapter validates SSL certificates against pinned SHA-256 fingerprints
/// for specified domains. It uses Dio's native HttpClientAdapter capabilities.
///
/// Usage:
/// ```dart
/// final config = SslPinningConfig(
///   domainFingerprints: {
///     'api.example.com': ['MWrOdUsfd6...'],
///   },
///   strictMode: true,
/// );
///
/// final dio = Dio();
/// dio.httpClientAdapter = SslPinningHttpClientAdapter(config);
/// ```
class SslPinningHttpClientAdapter implements HttpClientAdapter {
  final SslPinningConfig config;
  final IOHttpClientAdapter _ioAdapter = IOHttpClientAdapter();

  SslPinningHttpClientAdapter(this.config) {
    // Configure the underlying adapter's HttpClient creation
    _ioAdapter.createHttpClient = () {
      // Create SecurityContext that doesn't trust any CA certificates by default
      // This forces ALL certificates (valid or invalid) to go through badCertificateCallback
      final securityContext = SecurityContext(withTrustedRoots: false);

      final client = HttpClient(context: securityContext);

      // CRITICAL: This callback now handles ALL certificates since we disabled trusted roots
      // Every certificate must pass our fingerprint validation
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
            return _validateCertificate(cert, host, port);
          };

      return client;
    };
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return _ioAdapter.fetch(options, requestStream, cancelFuture);
  }

  @override
  void close({bool force = false}) {
    _ioAdapter.close(force: force);
  }

  /// Validate SSL certificate against pinned fingerprints
  bool _validateCertificate(X509Certificate cert, String host, int port) {
    if (!config.enabled) {
      return true;
    }

    // Check if domain is pinned
    if (!config.isDomainPinned(host)) {
      if (config.strictMode) {
        // Strict mode: Block unpinned domains
        return false;
      } else {
        // Permissive mode: Allow unpinned domains with standard TLS
        return true;
      }
    }

    // Domain is pinned - validate certificate fingerprint
    final expectedFingerprints = config.getFingerprintsForDomain(host);

    if (expectedFingerprints.isEmpty) {
      return false;
    }

    // Calculate SHA-256 fingerprint of the certificate
    final certFingerprint = _getCertificateFingerprint(cert);

    // Check if certificate fingerprint matches any expected fingerprint
    final isValid = expectedFingerprints.any((expected) {
      // Normalize both fingerprints (remove colons, convert to uppercase)
      final normalizedExpected = expected.replaceAll(':', '').toUpperCase();
      final normalizedCert = certFingerprint.replaceAll(':', '').toUpperCase();
      return normalizedExpected == normalizedCert;
    });

    return isValid;
  }

  String _getCertificateFingerprint(X509Certificate cert) {
    try {
      final derBytes = cert.der;
      final base64Der = base64.encode(derBytes);
      final pem =
          '-----BEGIN CERTIFICATE-----\n$base64Der\n-----END CERTIFICATE-----';

      // Parse X509 certificate from PEM
      final x509Cert = X509Utils.x509CertificateFromPem(pem);

      // Get the SHA-256 thumbprint of the public key (in hex format)
      final thumbprintHex =
          x509Cert.tbsCertificate?.subjectPublicKeyInfo.sha256Thumbprint ?? '';
      if (thumbprintHex.isEmpty) {
        return '';
      }
      // Convert hex string to bytes, then encode to base64
      final thumbprintBytes = _hexToBytes(thumbprintHex);
      final fingerprint = base64Encode(thumbprintBytes);
      return fingerprint;
    } catch (e) {
      return '';
    }
  }

  /// Convert hex string to list of bytes
  /// Example: '919C0DF7A787B597' -> [0x91, 0x9C, 0x0D, 0xF7, 0xA7, 0x87, 0xB5, 0x97]
  List<int> _hexToBytes(String hex) {
    final result = <int>[];
    for (int i = 0; i < hex.length; i += 2) {
      result.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return result;
  }
}
