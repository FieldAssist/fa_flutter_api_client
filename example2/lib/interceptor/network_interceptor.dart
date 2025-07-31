import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';
import 'package:fa_flutter_core/fa_flutter_core.dart';

import 'network/network_info.dart';

class MyNetworkInterceptor extends NetworkInterceptor {
  NetworkInfo networkInfo;

  MyNetworkInterceptor({required this.networkInfo});

  @override
  Future<bool> isInternetConnected() async {
    if (isWeb) {
      return true;
    }

    return networkInfo.isConnected;
  }
}
