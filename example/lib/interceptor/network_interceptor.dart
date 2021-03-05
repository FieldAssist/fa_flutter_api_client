import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';

import 'network/network_info.dart';

class MyNetworkInterceptor extends NetworkInterceptor {
  MyNetworkInterceptor({
    required this.networkInfo,
  });

  final NetworkInfo networkInfo;

  @override
  Future<bool> isInternetConnected() {
    return networkInfo.isConnected;
  }
}
