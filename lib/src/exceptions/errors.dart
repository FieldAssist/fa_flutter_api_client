import 'package:dio/dio.dart';

class ClientError extends DioError {
  ClientError({
    requestOptions,
    response,
    type = DioErrorType.other,
    error,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
        );

  @override
  String toString() {
    return 'Client Error: ${response!.statusCode} '
        '${response!.data ?? response!.statusMessage}';
  }
}

class ServerError extends DioError {
  ServerError({
    required requestOptions,
    response,
    type = DioErrorType.other,
    error,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
        );

  @override
  String toString() => 'Server Error: ${response!.statusCode} '
      '${response!.data ?? response!.statusMessage}';
}

class NoInternetError implements Exception {}

class UnstableInternetError extends DioError {
  UnstableInternetError({
    required requestOptions,
    response,
    type = DioErrorType.other,
    error,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
        );
}

class UnauthorizedError extends DioError {
  UnauthorizedError({
    required requestOptions,
    response,
    type = DioErrorType.other,
    error,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
        );
}

class UnknownApiError extends DioError {
  UnknownApiError({
    required requestOptions,
    response,
    type = DioErrorType.other,
    error,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
        );
}
