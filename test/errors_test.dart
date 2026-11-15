import 'package:dio/dio.dart';
import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final options = RequestOptions(path: '/login');
  // Dio hands a JSON error body to the error classes already decoded.
  final jsonBody = <String, dynamic>{'Message': 'Invalid code'};

  Response<dynamic> responseWith(int statusCode, dynamic data) =>
      Response(requestOptions: options, statusCode: statusCode, data: data);

  test('UnauthenticatedError.toString: JSON body → body as text', () {
    final error = UnauthenticatedError(
      requestOptions: options,
      response: responseWith(401, jsonBody),
    );

    expect(error.toString(), '{Message: Invalid code}');
  });

  test('UnauthenticatedError.toString: text body → body unchanged', () {
    final error = UnauthenticatedError(
      requestOptions: options,
      response: responseWith(401, 'Invalid code'),
    );

    expect(error.toString(), 'Invalid code');
  });

  test('UnauthenticatedError.toString: empty body → fallback text', () {
    final error = UnauthenticatedError(
      requestOptions: options,
      response: responseWith(401, ''),
    );

    expect(error.toString(), 'Unauthenticated, Please try again');
  });

  test('PreconditionFailedError.toString: JSON body → body as text', () {
    final error = PreconditionFailedError(
      requestOptions: options,
      response: responseWith(412, jsonBody),
    );

    expect(error.toString(), '{Message: Invalid code}');
  });

  test('ClientError.message: JSON body → body as text', () {
    final error = ClientError(
      requestOptions: options,
      response: responseWith(400, jsonBody),
    );

    expect(error.message, '{Message: Invalid code}');
  });
}
