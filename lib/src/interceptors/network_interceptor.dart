import 'package:dio/dio.dart';

import '../exceptions/errors.dart';

abstract class NetworkInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isConnected = await isInternetConnected();
    if (!isConnected) {
      // Intentional delay to mimic making server request behavior
      await Future.delayed(getDelay());
      return handler.reject(
        NoInternetError(
          requestOptions: options,
          response: Response(requestOptions: options),
          type: DioErrorType.other,
          error: 'No Internet Error',
        ),
      );
    }
    return handler.next(options);
  }

  Duration getDelay() {
    return Duration(milliseconds: 500);
  }

  Future<bool> isInternetConnected();
}
