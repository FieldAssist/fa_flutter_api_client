import 'package:dio/dio.dart';
import 'package:fa_flutter_core/fa_flutter_core.dart';

import '../../fa_flutter_api_client.dart';
import '../exceptions/errors.dart';

class NetworkInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isConnected = await NetworkConnectivityService.instance.isConnected;
    if (!isConnected) {
      // Intentional delay to mimic making server request behavior
      await Future.delayed(getDelay());
      return handler.reject(
        NoInternetError(
          requestOptions: options,
          response: Response(requestOptions: options),
          type: DioExceptionType.unknown,
          error: 'No Internet Error',
        ),
      );
    }
    return handler.next(options);
  }

  Duration getDelay() {
    return Duration(milliseconds: 500);
  }
}
