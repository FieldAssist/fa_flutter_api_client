import 'package:example2/interceptor/auth_interceptor.dart';
import 'package:example2/interceptor/logging_interceptor.dart';
import 'package:example2/interceptor/network/network_info.dart';
import 'package:example2/interceptor/network_interceptor.dart';
import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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
