import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';
import 'package:fa_flutter_api_client/src/utils/constants.dart';

abstract class ErrorInterceptor extends Interceptor {
  ErrorInterceptor({
    this.showStackTrace = false,
  });

  final bool showStackTrace;
  @override
  Future<void> onError(
    DioException error,
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
    if (error.type == DioExceptionType.badResponse) {
      final code = error.response!.statusCode;
      if (code == 401) {
        final unauthenticatedError = UnauthenticatedError.fromDioError(error);
        // IF headers contains key [isAuthRequired]
        // then not clearing auth data when 401 occurs
        final isLoginApi = checkIsLoginApi(unauthenticatedError);
        // Delaying for 300ms so that other futures
        // can complete before navigating to unauthorizedScreen
        Future.delayed(
          const Duration(milliseconds: 300),
          () {
            if (!isLoginApi) {
              handleUnauthenticatedUser(unauthenticatedError);
            }
            return handler.reject(
              UnauthenticatedError(
                requestOptions: error.requestOptions,
                response: error.response,
                type: error.type,
                error: error.error,
              ),
            );
          },
        );
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
      } else if (code == 412) {
        return handler.reject(
          PreconditionFailedError(
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
            showStackTrace: showStackTrace,
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
    } else if (error.type == DioExceptionType.connectionTimeout) {
      return handler.reject(
        UnstableInternetError(
          requestOptions: error.requestOptions,
          response: error.response,
          type: error.type,
          error: error.error,
        ),
      );
    }

    if (error.type == DioErrorType.cancel) {
      return handler.reject(RequestCancelError.fromDioError(error));
    }

    return handler.reject(
      UnknownApiError(
        requestOptions: error.requestOptions,
        response: error.response,
        type: error.type,
        error: error.error,
        showStackTrace: showStackTrace,
      ),
    );
  }

  bool checkIsLoginApi(UnauthenticatedError error) {
    return error.requestOptions.headers
        .containsKey(Constants.isAuthRequiredAPIKey);
  }

  /// It will be called when `401` occurs and [isAuthRequiredAPIKey] is not present in headers
  FutureOr handleUnauthenticatedUser(UnauthenticatedError error);
}
