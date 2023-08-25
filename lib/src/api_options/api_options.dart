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

  Duration? receiveTimeout;

  Duration? sendTimeout;

  bool? refreshCache;

  @deprecated
  Duration? expireDuration;

  DateTime? expireTime;
}
