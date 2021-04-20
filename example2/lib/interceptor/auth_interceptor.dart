import 'package:dio/dio.dart';
import 'package:fa_flutter_core/fa_flutter_core.dart';

class MyAuthInterceptor extends Interceptor {
  MyAuthInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = "";
    if (checkIfNotEmpty(token)) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}
