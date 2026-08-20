import 'dart:io';

import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiServiceImpl Accept-Encoding header on the wire', () {
    late HttpServer server;
    List<String>? receivedAcceptEncoding;

    setUp(() async {
      receivedAcceptEncoding = null;
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) {
        receivedAcceptEncoding = request.headers['accept-encoding'];
        request.response
          ..statusCode = 200
          ..headers.contentType = ContentType.json
          ..write('{}')
          ..close();
      });
    });

    tearDown(() async {
      await server.close(force: true);
    });

    test('sends Accept-Encoding: identity when enableCompression is false', () async {
      final service = ApiServiceImpl(
        baseUrl: 'http://${server.address.address}:${server.port}/',
      );

      await service.get(endpoint: '');

      expect(receivedAcceptEncoding, ['identity']);
    });

    test('sends Accept-Encoding: br when enableCompression is true', () async {
      final service = ApiServiceImpl(
        baseUrl: 'http://${server.address.address}:${server.port}/',
        enableCompression: true,
      );

      await service.get(endpoint: '');

      expect(receivedAcceptEncoding, ['br']);
    });
  });
}
