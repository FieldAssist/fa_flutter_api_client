import 'package:dio/dio.dart';
import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';
import 'package:fa_flutter_core/fa_flutter_core.dart';

class MyAuthInterceptor extends Interceptor {
  MyAuthInterceptor();

  @override
  Future onRequest(RequestOptions options) async {
    final isConnected = true;
    if (!isConnected) {
      throw NoInternetError();
    }
    final token = "";
    if (checkIfNotEmpty(token)) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return options;
  }
}
