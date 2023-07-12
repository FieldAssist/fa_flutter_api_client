import 'package:dio/dio.dart';
import 'package:fa_flutter_core/fa_flutter_core.dart';

class ClientError extends DioException {
  ClientError({
    requestOptions,
    response,
    type = DioExceptionType.unknown,
    error,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
        );

  @override
  String get message => response?.data ?? toString();

  @override
  String toString() {
    return 'Client Error: ${response!.statusCode} '
        '${response!.data ?? response!.statusMessage}';
  }
}

class ServerError extends DioException {
  ServerError({
    required requestOptions,
    response,
    type = DioExceptionType.unknown,
    error,
    this.showStackTrace = false,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
        );

  /// showStackTrace true means DEV flavor
  final bool showStackTrace;

  @override
  String toString() {
    if (!showStackTrace) {
      return 'Server Error: ${response!.statusCode} '
          'Something Went Wrong!';
    }
    return 'Server Error: ${response!.statusCode} '
        '${response!.data ?? response!.statusMessage}';
  }
}

class UnauthorizedError extends DioException {
  UnauthorizedError({
    required requestOptions,
    response,
    type = DioExceptionType.unknown,
    error,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
        );

  @override
  String toString() {
    return checkIfNotEmpty(response?.data)
        ? response?.data
        : 'Unauthorized, Please try again';
  }
}

class PreconditionFailedError extends DioException {
  PreconditionFailedError({
    required requestOptions,
    response,
    type = DioExceptionType.unknown,
    error,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
        );

  @override
  String toString() {
    return checkIfNotEmpty(response?.data)
        ? response?.data
        : 'Access to the target resource has been denied';
  }
}

class UnauthenticatedError extends DioException {
  UnauthenticatedError({
    required requestOptions,
    response,
    type = DioExceptionType.unknown,
    error,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
        );

  @override
  String toString() {
    return checkIfNotEmpty(response?.data)
        ? response?.data
        : 'Unauthenticated, Please try again';
  }

  UnauthenticatedError.fromDioError(DioError error)
      : super(
          requestOptions: error.requestOptions,
          response: error.response,
          type: error.type,
          error: error,
        );
}

class UnknownApiError extends DioException {
  UnknownApiError({
    required requestOptions,
    response,
    type = DioExceptionType.unknown,
    error,
    this.showStackTrace = false,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
        );

  /// showStackTrace true means DEV flavor
  final bool showStackTrace;

  @override
  String toString() {
    if (!showStackTrace) {
      return 'Oops! Something went wrong.';
    }
    return 'Oops! Something went wrong.\n\n${super.toString()}';
  }
}

class NoInternetError extends DioException {
  NoInternetError({
    required requestOptions,
    response,
    type = DioExceptionType.unknown,
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

class UnstableInternetError extends DioException {
  UnstableInternetError({
    required requestOptions,
    response,
    type = DioExceptionType.unknown,
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
