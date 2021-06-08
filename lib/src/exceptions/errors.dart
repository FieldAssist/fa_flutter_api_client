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

  @override
  String toString() {
    return 'Unauthorized, Please try again';
  }
}

class UnauthenticatedError extends DioError {
  UnauthenticatedError({
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
  String toString() {
    return 'Unauthenticated, Please try again';
  }
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

  @override
  String toString() {
    return 'Oops! Something went wrong.\n\n${super.toString()}';
  }
}

class NoInternetError extends DioError {
  NoInternetError({
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
  String toString() {
    return 'Please check your internet connection';
  }
}

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

  @override
  String toString() {
    return 'Poor internet connection';
  }
}
