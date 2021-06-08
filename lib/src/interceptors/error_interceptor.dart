import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';

class ErrorInterceptor extends Interceptor {
  @override
  Future<void> onError(
    DioError error,
    ErrorInterceptorHandler handler,
  ) async {
    if (error is NoInternetError) {
      return handler.reject(
        NoInternetError(
          requestOptions: error.requestOptions,
          response: error.response,
          type: error.type,
          error: error.error,
        ),
      );
    }
    if (error.type == DioErrorType.response) {
      final code = error.response!.statusCode;
      if (code == 401) {
        // Delaying for 300ms so that other futures
        // can complete before navigating to unauthorizedScreen
        Future.delayed(
          const Duration(milliseconds: 300),
          handleUnauthenticatedUser,
        );
        // Returning null as we handled the error
        return null;
      } else if (code == 403) {
        return handler.reject(
          UnauthorizedError(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: error.error,
          ),
        );
      } else if (code! >= 400 && code < 500) {
        return handler.reject(
          ClientError(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: error.error,
          ),
        );
      } else if (code >= 500 && code < 600) {
        return handler.reject(
          ServerError(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: error.error,
          ),
        );
      } else if (error.error is SocketException) {
        return handler.reject(
          UnstableInternetError(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: error.error,
          ),
        );
      }
    }
    return handler.reject(
      UnknownApiError(
        requestOptions: error.requestOptions,
        response: error.response,
        type: error.type,
        error: error.error,
      ),
    );
  }

  FutureOr handleUnauthenticatedUser() {
    return throw UnimplementedError();
  }
}
