import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkConnectivityService {
  NetworkConnectivityService._internal()
      : connectionChecker = InternetConnectionChecker.createInstance(
          addresses: [
            AddressCheckOption(uri: Uri.parse('https://www.google.com')),
            AddressCheckOption(uri: Uri.parse('https://www.bing.com')),
            AddressCheckOption(uri: Uri.parse('https://www.amazon.com')),
            AddressCheckOption(uri: Uri.parse('https://www.cloudflare.com')),
          ],
        );

  static NetworkConnectivityService? _instance;

  static NetworkConnectivityService get instance {
    _instance ??= NetworkConnectivityService._internal();
    return _instance!;
  }

  final InternetConnectionChecker connectionChecker;

  Future<bool> get isConnected => connectionChecker.hasConnection;
}
