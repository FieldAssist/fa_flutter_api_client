import 'dart:developer';

import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';

/// This is only for refresh token logging
/// Do not use it for other purposes
class RefreshTokenLoggingInterceptorImpl extends LoggingInterceptor {
  @override
  void logPrint(String msg) {
    log(msg);
  }
}
