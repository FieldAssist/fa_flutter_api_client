import 'package:dio/dio.dart';

class ApiOptions {
  ApiOptions({
    this.headers = const {},
    this.receiveTimeout,
    this.sendTimeout,
    this.connectTimeout,
    this.refreshCache,
    this.cacheResponse,
    this.expireDuration,
    this.cancelToken,
    this.ignoreAutoRefresh = true,
    this.responseType,
    this.isolateDecodeThreshold,
  });
  ResponseType? responseType;

  Map<String, dynamic>? headers;

  Duration? receiveTimeout;

  Duration? sendTimeout;

  Duration? connectTimeout;

  bool? refreshCache;

  bool? cacheResponse;

  Duration? expireDuration;

  CancelToken? cancelToken;

  bool? ignoreAutoRefresh;

  /// Content-length threshold (in bytes) above which response JSON decoding
  /// moves to a Dio worker isolate. Only honored when set on the [ApiOptions]
  /// passed to `ApiServiceImpl`'s constructor (transformers are client-scoped,
  /// so per-request values are ignored). `null` uses the client default of
  /// 50 KiB. `-1` keeps all decoding on the main isolate; `0` sends every
  /// decode to an isolate.
  int? isolateDecodeThreshold;
}
