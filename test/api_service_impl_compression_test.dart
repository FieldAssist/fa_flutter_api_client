import 'package:dio/dio.dart';
import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';
import 'package:fa_flutter_api_client/src/compression/brotli_transformer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiServiceImpl enableCompression', () {
    test('defaults to false, setting Accept-Encoding: identity on every internal Dio client', () {
      final service = ApiServiceImpl(baseUrl: 'https://example.com/');

      expect(service.enableCompression, false);

      final clients = <Dio?>[
        service.getApiClient(),
        service.getDioFile(),
        service.getRefreshTokenApiClient(),
      ];

      for (final dio in clients) {
        expect(dio!.options.headers['Accept-Encoding'], 'identity');
        expect(dio.transformer, isNot(isA<BrotliTransformer>()));
      }
    });

    test('when true, sets Accept-Encoding: br and BrotliTransformer on every internal Dio client', () {
      final service = ApiServiceImpl(
        baseUrl: 'https://example.com/',
        enableCompression: true,
      );

      final clients = <Dio?>[
        service.getApiClient(),
        service.getDioFile(),
        service.getRefreshTokenApiClient(),
      ];

      for (final dio in clients) {
        expect(dio!.options.headers['Accept-Encoding'], 'br');
        expect(dio.transformer, isA<BrotliTransformer>());
      }
    });
  });
}
