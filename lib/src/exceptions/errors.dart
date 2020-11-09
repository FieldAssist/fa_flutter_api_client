import 'package:dio/dio.dart';

class ClientError extends DioError {
  ClientError({
    request,
    response,
    type = DioErrorType.DEFAULT,
    error,
  }) : super(
          request: request,
          response: response,
          type: type,
          error: error,
        );

  @override
  String toString() {
    return 'Server Error: ${response.statusCode} '
        '${response.data ?? response.statusMessage}';
  }
}

class ServerError extends DioError {
  ServerError(this.msg);

  final String msg;

  @override
  String toString() => msg;
}

class NoInternetError extends DioError {}

class UnauthorizedError extends DioError {}

class UnknownError extends DioError {
  UnknownError(this.msg);

  final String msg;

  @override
  String toString() => msg;
}
