import 'dart:async';

import 'package:dio/dio.dart';

/// [LoggingInterceptor] is used to print logs during network requests.
/// It's better to add [LoggingInterceptor] to the tail of the interceptor queue,
/// otherwise the changes made in the interceptor behind A will not be printed out.
/// This is because the execution of interceptors is in the order of addition.

abstract class LoggingInterceptor extends Interceptor {
  LoggingInterceptor();

  @override
  Future onRequest(RequestOptions options) async {
    logPrint('*** API Request - Start ***');

    printKV('URI', options.uri);
    printKV('METHOD', options.method);
    logPrint('HEADERS:');
    options.headers.forEach((key, v) => printKV(' - $key', v));
    logPrint('BODY:');
    printAll(options.data ?? "");

    logPrint('*** API Request - End ***');
  }

  @override
  Future onError(DioError err) async {
    logPrint('*** Api Error - Start ***:');

    logPrint('URI: ${err.request!.uri}');
    if (err.response != null) {
      logPrint('STATUS CODE: ${err.response!.statusCode?.toString()}');
    }
    logPrint('$err');
    if (err.response != null) {
      printKV('REDIRECT', err.response!.isRedirect);
      logPrint('BODY:');
      printAll(err.response?.toString());
    }

    logPrint('*** Api Error - End ***:');
    return err;
  }

  @override
  Future onResponse(Response response) async {
    logPrint('*** Api Response - Start ***');

    printKV('URI', response.request.uri);
    printKV('STATUS CODE', response.statusCode);
    printKV('REDIRECT', response.isRedirect);
    logPrint('BODY:');
    printAll(response.data ?? "");

    logPrint('*** Api Response - End ***');

    return response;
  }

  void printKV(String key, Object? v) {
    logPrint('$key: $v');
  }

  void printAll(msg) {
    msg.toString().split('\n').forEach(logPrint);
  }

  void logPrint(String msg);
}
