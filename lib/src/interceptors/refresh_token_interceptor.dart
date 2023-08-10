import 'dart:async';

import 'package:dio/dio.dart';

abstract class RefreshTokenInterceptor extends QueuedInterceptorsWrapper {
  bool isRefreshingSession = false;

  @override
  FutureOr<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      var updatedOptions = options;
      if (isExpired(options)) {
        updatedOptions = await refreshToken(options);
      }
      return handler.next(updatedOptions);
    } catch (e) {
      handler.next(options);
    }
  }

  /// It will be called when [isExpired] is true
  /// Return the updated [RequestOptions] with new token
  FutureOr<RequestOptions> refreshToken(RequestOptions options);

  bool isExpired(RequestOptions options);
}
