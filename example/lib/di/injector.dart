import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:example/interceptor/auth_interceptor.dart';
import 'package:example/interceptor/error_interceptor.dart' as e;
import 'package:example/interceptor/logging_interceptor.dart';
import 'package:example/interceptor/network/network_info.dart';
import 'package:example/interceptor/network_interceptor.dart';
import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';
import 'package:get_it/get_it.dart';

const _debugBaseUrl = 'https://fa-maapins-debug.fieldassist.io/api/';

final locator = GetIt.instance;

class Injector {
  Future<void> init() async {
    // New Api Helper
    // NetworkInfo
    locator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(
        connectionChecker: DataConnectionChecker(),
      ),
    );

    final interceptors = [
      MyNetworkInterceptor(networkInfo: locator()),
      MyAuthInterceptor(),
      e.ErrorInterceptor(),
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
