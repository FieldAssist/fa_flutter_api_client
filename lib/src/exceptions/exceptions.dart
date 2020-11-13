import 'package:fa_flutter_core/fa_flutter_core.dart';

class ClientException extends MyException {
  const ClientException({
    this.msg,
    this.statusCode,
  }) : super(msg);
  final String msg;
  final int statusCode;

  @override
  String toString() {
    return 'Server Error: $statusCode $msg';
  }
}

class NoInternetException extends MyException {
  const NoInternetException() : super('Please check your internet connection');
}

class ServerException extends MyException {
  const ServerException(String message) : super(message);
}

class UnauthorizedException extends MyException {
  const UnauthorizedException() : super('Unauthorized, Please try again');
}

class UnknownException extends MyException {
  const UnknownException(String msg)
      : super(msg ?? 'Some unknown error occured, Please try again');
}
