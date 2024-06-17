import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';
import 'package:fa_flutter_api_client/src/implementations/refresh_token_logging_interceptor_impl.dart';
import 'package:fa_flutter_api_client/src/utils/constants.dart';
import 'package:fa_flutter_core/fa_flutter_core.dart' hide ProgressCallback;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class ApiServiceImpl implements ApiService {
  ApiServiceImpl({
    required this.baseUrl,
    this.interceptors,
    this.apiOptions,
  }) {
    _dio = Dio()
      ..options.contentType = Headers.jsonContentType
      ..options.connectTimeout = Duration(minutes: 1)
      ..options.receiveTimeout = Duration(minutes: 1, seconds: 30);

    if (interceptors != null && interceptors!.isNotEmpty) {
      _dio!.interceptors.addAll(interceptors!);
    }

    _dioFile = Dio()
      ..options.connectTimeout = Duration(minutes: 1)
      ..options.receiveTimeout = Duration(minutes: 1, seconds: 30);

    if (interceptors != null && interceptors!.isNotEmpty) {
      _dioFile!.interceptors.addAll(interceptors!);
    }

    _refreshTokenDio = Dio();
    if (interceptors != null && interceptors!.isNotEmpty && isDebug) {
      _refreshTokenDio!.interceptors.add(
        RefreshTokenLoggingInterceptorImpl(),
      );
    }
  }

  String baseUrl;
  Dio? _dio;
  ApiOptions? apiOptions;

  Dio? _refreshTokenDio;

  Dio? _dioFile;

  final List<Interceptor>? interceptors;

  @override
  Future<Response<T>> get<T>({
    String? endpoint,
    String? url,
    ApiOptions? options,
  }) async {
    return _dio!.get<T>(checkIfNotEmpty(url) ? '$url' : '$baseUrl$endpoint',
        cancelToken: options?.cancelToken,
        options: Options(
          headers: _formatHeaders(options),
          receiveTimeout: options?.receiveTimeout,
          sendTimeout: options?.sendTimeout,
        ));
  }

  @override
  Future<Response<T>> post<T>({
    String? endpoint,
    String? url,
    String? body,
    ApiOptions? options,
    bool isRefreshTokenRequest = false,
  }) async {
    if (isRefreshTokenRequest) {
      return _refreshTokenDio!.post<T>(
        url ?? '$baseUrl$endpoint',
        data: body,
        options: Options(
          headers: _formatHeaders(options),
          receiveTimeout: options?.receiveTimeout,
          sendTimeout: options?.sendTimeout,
        ),
      );
    }

    return _dio!.post<T>(url ?? '$baseUrl$endpoint',
        data: body,
        cancelToken: options?.cancelToken,
        options: Options(
          headers: _formatHeaders(options),
          receiveTimeout: options?.receiveTimeout,
          sendTimeout: options?.sendTimeout,
        ));
  }

  @override
  Future<Response<T>> delete<T>({
    String? endpoint,
    ApiOptions? options,
  }) async {
    return _dio!.delete<T>('$baseUrl$endpoint',
        cancelToken: options?.cancelToken,
        options: Options(
          headers: _formatHeaders(options),
          receiveTimeout: options?.receiveTimeout,
          sendTimeout: options?.sendTimeout,
        ));
  }

  @override
  Future<Response<T>> put<T>({
    String? endpoint,
    String? body,
    ApiOptions? options,
  }) async {
    return _dio!.put<T>('$baseUrl$endpoint',
        cancelToken: options?.cancelToken,
        data: body,
        options: Options(
          headers: _formatHeaders(options),
          receiveTimeout: options?.receiveTimeout,
          sendTimeout: options?.sendTimeout,
        ));
  }

  @override
  Future<Response<T>> patch<T>({
    String? endpoint,
    String? body,
    ApiOptions? options,
  }) async {
    return _dio!.patch<T>('$baseUrl$endpoint',
        data: body,
        options: Options(
          headers: _formatHeaders(options),
          receiveTimeout: options?.receiveTimeout,
          sendTimeout: options?.sendTimeout,
        ));
  }

  @override
  Future<Response<T>> postFile<T>({
    String? endpoint,
    String? url,
    String? keyName,
    File? file,
    ProgressCallback? onSendProgress,
    ApiOptions? options,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? dataParameters,
  }) async {
    // if the endpoint is not passed use url parameter
    // if both of them are null then use default fileUploadUrl

    endpoint =
        endpoint != null ? "$baseUrl$endpoint" : url ?? getFileUploadUrl();
    if (queryParameters != null) {
      var queryUrl = "";
      for (final parameter in queryParameters.entries) {
        queryUrl =
            "${queryUrl.isEmpty ? '?' : '&'}${parameter.key}=${parameter.value}";
      }
      endpoint = "$endpoint$queryUrl";
    }
    keyName = keyName ?? 'asset';
    if (file == null) {
      throw const MyException("Attached file is null");
    }
    final fileName = basename(file.path);
    var mimeType = mime(fileName);
    mimeType ??= 'application/octet-stream';
    final type = mimeType.split('/')[0];
    final subType = mimeType.split('/')[1];

    Map<String, dynamic> formDataMap = {
      keyName: await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: MediaType(type, subType),
      ),
    };

    if (dataParameters != null) {
      formDataMap.addAll(dataParameters);
    }

    final formData = FormData.fromMap(formDataMap);

    return _dioFile!.post<T>(
      endpoint,
      cancelToken: options?.cancelToken,
      data: formData,
      onSendProgress: onSendProgress,
    );
  }

  @override
  void setBaseUrl(String baseUrl) {
    this.baseUrl = baseUrl;
  }

  @override
  String getBaseUrl() {
    return baseUrl;
  }

  @override
  String getFileUploadUrl() {
    return '${baseUrl}upload';
  }

  @override
  Dio? getDioFile() {
    return _dioFile;
  }

  @override
  Dio? getApiClient() {
    return _dio;
  }

  @override
  Dio getRefreshTokenApiClient() {
    if (_refreshTokenDio == null) {
      _refreshTokenDio = Dio();
    }

    return _refreshTokenDio!;
  }

  @override
  String getIsAuthRequiredKey() => Constants.isAuthRequiredAPIKey;

  Map<String, dynamic> _formatHeaders(ApiOptions? options) {
    final headers = {
      ...options?.headers ?? {},
    };
    final _now = DateTime.now();
    final _midnightTime =
        DateTime(_now.year, _now.month, _now.day + 1).subtract(
      Duration(
        seconds: 1,
      ),
    );
    final expireDuration =
        options?.expireDuration ?? apiOptions?.expireDuration;
    headers['appSpecificHeaders'] = {
      "forceRefreshCache":
          options?.refreshCache ?? apiOptions?.refreshCache ?? false,
      "expirationTime": expireDuration != null
          ? _now.add(expireDuration).toString()
          : _midnightTime.toString(),
      "expireDuration": options?.expireDuration ?? apiOptions?.expireDuration,
      "ignoreAutoRefresh":
          options?.ignoreAutoRefresh ?? apiOptions?.ignoreAutoRefresh ?? false,
      "cacheResponse":
          options?.cacheResponse ?? apiOptions?.cacheResponse ?? true
    };
    return headers;
  }

  @override
  Future<String> requestTranformer(RequestOptions options) {
    return _dio!.transformer.transformRequest(options);
  }
}
