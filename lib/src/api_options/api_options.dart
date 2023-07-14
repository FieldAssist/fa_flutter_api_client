class ApiOptions {
  ApiOptions({
    this.headers = const {},
    this.receiveTimeout,
    this.sendTimeout,
    this.refreshCache,
    this.expireDuration,
    this.expireTime,
  });

  Map<String, dynamic>? headers;

  int? receiveTimeout;

  int? sendTimeout;

  bool? refreshCache;

  @deprecated
  Duration? expireDuration;

  DateTime? expireTime;
}
