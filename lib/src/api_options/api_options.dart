import 'package:dio/dio.dart';
import 'package:fa_flutter_api_client/src/utils/api_type.dart';

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
    this.apiType = ApiType.global,
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

  ApiType apiType;
}
