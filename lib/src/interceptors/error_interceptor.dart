import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fa_flutter_api_client/src/exceptions/errors.dart';

abstract class ErrorInterceptor extends Interceptor {
  @override
  Future onError(DioError err) async {
    if (err is NoInternetError) {
      return NoInternetError();
    } else if (err.type == DioErrorType.RESPONSE) {
      final code = err.response.statusCode;
      if (code == 401) {
        await onUnauthorizedError();
        return UnauthorizedError();
      } else if (code >= 400 && code < 500) {
        return ClientError(
          request: err.request,
          response: err.response,
          type: err.type,
          error: err.error,
        );
      } else if (code >= 500 && code < 600) {
        return ServerError(
          'Server Error: ${err.response.statusCode} '
          '${err.response.data ?? err.response.statusMessage}',
        );
      }
    } else if (err.error is SocketException) {
      return NoInternetError();
    }
    return UnknownError(err?.toString());
  }

  Future<void> onUnauthorizedError();
}
