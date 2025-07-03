import 'package:dio/dio.dart';

class ApiOptions {
  ApiOptions({
    this.headers = const {},
    this.receiveTimeout,
    this.sendTimeout,
    this.refreshCache,
    this.cacheResponse,
    this.expireDuration,
    this.cancelToken,
    this.ignoreAutoRefresh = false,
  });

  Map<String, dynamic>? headers;

  Duration? receiveTimeout;

  Duration? sendTimeout;

  bool? refreshCache;

  bool? cacheResponse;

  Duration? expireDuration;

  CancelToken? cancelToken;

  bool? ignoreAutoRefresh;
}
