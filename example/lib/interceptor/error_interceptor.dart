import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';

class ErrorInterceptor extends Interceptor {
  @override
  Future onError(DioError error) async {
    if (error is NoInternetError) {
      return NoInternetError();
    }
    if (error.type == DioErrorType.RESPONSE) {
      final code = error.response.statusCode;
      if (code == 401 || code == 403) {
        // Delaying for 300ms so that other futures
        // can complete before navigating to unauthorizedScreen
        Future.delayed(
          const Duration(milliseconds: 300),
          handleUnauthorizedUser,
        );
        // Returning null as we handled the error
        return null;
      } else if (code >= 400 && code < 500) {
        return ClientError(
          request: error.request,
          response: error.response,
          type: error.type,
          error: error.error,
        );
      } else if (code >= 500 && code < 600) {
        return ServerError(
          'Server Error: ${error.response.statusCode} '
          '${error.response.data ?? error.response.statusMessage}',
        );
      } else if (error.error is SocketException) {
        return NoInternetError();
      }
    }
    return UnknownError(error?.toString());
  }

  FutureOr handleUnauthorizedUser() {
    return throw UnimplementedError();
  }
}
