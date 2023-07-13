import 'package:dio/dio.dart';

abstract class CancelTokenInterceptor extends Interceptor {
  CancelTokenInterceptor() : appCancelToken = AppCancelToken();

  final AppCancelToken appCancelToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (shouldAddCancelToken(options.path)) {
      final cancelToken = appCancelToken.getCancelToken();
      options.cancelToken = cancelToken;
    }
    handler.next(options);
  }

  bool shouldAddCancelToken(String path);
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
