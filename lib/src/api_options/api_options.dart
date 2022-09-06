class ApiOptions {
  ApiOptions({
    this.headers = const {},
    this.receiveTimeout,
    this.sendTimeout,
    this.refreshCache,
    this.expireDuration,
  });

  Map<String, dynamic>? headers;

  int? receiveTimeout;

  int? sendTimeout;

  bool? refreshCache;

  Duration? expireDuration;
}
