import 'dart:typed_data';

import 'package:brotli/brotli.dart';
import 'package:dio/dio.dart';

/// Decompresses Brotli-encoded responses (`content-encoding: br`) before
/// handing them to [BackgroundTransformer] for the normal decode. Requests
/// pass through untouched; non-Brotli responses pass through untouched too.
class BrotliTransformer extends Transformer {
  BrotliTransformer() : _inner = BackgroundTransformer();

  final Transformer _inner;

  @override
  Future<String> transformRequest(RequestOptions options) {
    return _inner.transformRequest(options);
  }

  @override
  Future<dynamic> transformResponse(
    RequestOptions options,
    ResponseBody responseBody,
  ) async {
    if (!_isBrotliEncoded(responseBody.headers)) {
      return _inner.transformResponse(options, responseBody);
    }

    final compressedBytes = await _consolidate(responseBody.stream);
    final decompressedBytes = brotliDecode(compressedBytes);

    final headers = Map<String, List<String>>.from(responseBody.headers)
      ..remove(Headers.contentEncodingHeader)
      ..remove(Headers.contentLengthHeader);

    final decompressedBody = ResponseBody.fromBytes(
      decompressedBytes,
      responseBody.statusCode,
      statusMessage: responseBody.statusMessage,
      isRedirect: responseBody.isRedirect,
      headers: headers,
    );

    return _inner.transformResponse(options, decompressedBody);
  }

  bool _isBrotliEncoded(Map<String, List<String>> headers) {
    final values = headers[Headers.contentEncodingHeader];
    if (values == null) return false;
    return values.any((value) => value.toLowerCase().contains('br'));
  }

  Future<Uint8List> _consolidate(Stream<Uint8List> stream) async {
    final builder = BytesBuilder(copy: false);
    await for (final chunk in stream) {
      builder.add(chunk);
    }
    return builder.takeBytes();
  }
}
