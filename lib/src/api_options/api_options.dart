class ApiOptions {
  ApiOptions({
    this.headers,
    this.receiveTimeout,
    this.sendTimeout,
  });

  Map<String, dynamic>? headers;

  int? receiveTimeout;

  int? sendTimeout;
}
