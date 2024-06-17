import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';
import 'package:fa_flutter_core/fa_flutter_core.dart';

import '../interceptor/auth_interceptor.dart';
import '../interceptor/logging_interceptor.dart';
import '../interceptor/network/network_info.dart';
import '../interceptor/network_interceptor.dart';

const _debugBaseUrl = 'https://fa-maapins-debug.fieldassist.io/api/';

final locator = GetIt.instance;

class Injector {
  Future<void> init() async {
    locator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(
        connectionChecker: InternetConnectionChecker(),
      ),
    );

    final interceptors = [
      MyNetworkInterceptor(networkInfo: locator()),
      MyAuthInterceptor(),
      // ErrorInterceptor(),
      MyLoggingInterceptor(),
    ];
    locator.registerLazySingleton<ApiService>(() {
      return ApiServiceImpl(
        baseUrl: _debugBaseUrl,
        interceptors: interceptors,
      );
    });
  }
}
