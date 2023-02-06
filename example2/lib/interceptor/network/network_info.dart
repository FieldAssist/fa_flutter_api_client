import 'package:fa_flutter_core/fa_flutter_core.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl({@required this.connectionChecker});

  final InternetConnectionChecker? connectionChecker;

  @override
  Future<bool> get isConnected =>
      isWeb ? Future<bool>.value(true) : connectionChecker!.hasConnection;
}
