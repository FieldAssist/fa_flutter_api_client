import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fa_flutter_api_client/src/compression/brotli_transformer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BrotliTransformer', () {
    test('decodes a response whose content-encoding is br', () async {
      // Brotli-compressed bytes for '{"message":"hello brotli","count":2}',
      // produced with the reference `brotli` CLI (verified round-trip).
      final compressedBytes = base64Decode(
        'jxGAeyJtZXNzYWdlIjoiaGVsbG8gYnJvdGxpIiwiY291bnQiOjJ9Aw==',
      );
      final responseBody = ResponseBody.fromBytes(
        compressedBytes,
        200,
        headers: {
          'content-type': ['application/json'],
          'content-encoding': ['br'],
        },
      );

      final data = await BrotliTransformer().transformResponse(
        RequestOptions(path: '/test'),
        responseBody,
      );

      expect(data, {'message': 'hello brotli', 'count': 2});
    });

    test('passes through a response with no content-encoding unchanged', () async {
      final responseBody = ResponseBody.fromString(
        '{"message":"plain","count":1}',
        200,
        headers: {
          'content-type': ['application/json'],
        },
      );

      final data = await BrotliTransformer().transformResponse(
        RequestOptions(path: '/test'),
        responseBody,
      );

      expect(data, {'message': 'plain', 'count': 1});
    });
  });
}
