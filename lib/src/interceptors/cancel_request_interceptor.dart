import 'package:dio/dio.dart';

class CancelTokenInterceptor extends Interceptor {
  CancelTokenInterceptor() : appCancelToken = AppCancelToken();

  final AppCancelToken appCancelToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.cancelToken = appCancelToken.getCancelToken();
    handler.next(options);
  }
}

class AppCancelToken {
  CancelToken _cancelToken = CancelToken();

  CancelToken getCancelToken() {
    if (_cancelToken.isCancelled) {
      _cancelToken = CancelToken();
    }

    return _cancelToken;
  }
}
