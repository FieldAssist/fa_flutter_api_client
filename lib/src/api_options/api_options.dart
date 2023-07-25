class ApiOptions {
  ApiOptions({
    this.headers = const {},
    this.receiveTimeout,
    this.sendTimeout,
    this.refreshCache,
    this.expireDuration = const Duration(days: 1),
  });

  Map<String, dynamic>? headers;

  int? receiveTimeout;

  int? sendTimeout;

  bool? refreshCache;

  Duration? expireDuration;
}
