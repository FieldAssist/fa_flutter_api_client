import 'package:dio/dio.dart';

class ApiOptions {
  ApiOptions({
    this.headers = const {},
    this.receiveTimeout,
    this.sendTimeout,
    this.refreshCache,
    this.expireDuration = const Duration(days: 1),
    this.cancelToken,
  });

  Map<String, dynamic>? headers;

  Duration? receiveTimeout;

  Duration? sendTimeout;

  bool? refreshCache;

  Duration? expireDuration;

  CancelToken? cancelToken;
}
