import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';
import 'package:fa_flutter_core/fa_flutter_core.dart';

final logger = AppLogImpl();

class MyLoggingInterceptor extends LoggingInterceptor {
  @override
  void logPrint(String msg) {
    logger.i(msg);
  }
}
