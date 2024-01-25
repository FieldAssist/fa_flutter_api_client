import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fa_flutter_api_client/src/api_options/api_options.dart';
import 'package:fa_flutter_api_client/src/utils/constants.dart';
import 'package:fa_flutter_core/fa_flutter_core.dart' hide ProgressCallback;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

import 'base/api_service.dart';

class ApiServiceImpl implements ApiService {
  ApiServiceImpl({
    required this.baseUrl,
    this.interceptors,
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
  }

  String baseUrl;
  Dio? _dio;

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
  }) async {
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
  Future<Response<T>> postFile<T>({
    String? endpoint,
    String? url,
    String? keyName,
    File? file,
    ProgressCallback? onSendProgress,
    ApiOptions? options,
    Map<String, dynamic>? queryParameters,
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
    final formData = FormData.fromMap({
      keyName: await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: MediaType(type, subType),
      ),
    });
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
    headers['appSpecificHeaders'] = {
      "forceRefreshCache": options?.refreshCache ?? false,
      "expirationTime": options?.expireDuration != null
          ? _now.add(options!.expireDuration!).toString()
          : _midnightTime.toString(),
      "expireDuration": options?.expireDuration
    };
    return headers;
  }

  @override
  Future<String> requestTranformer(RequestOptions options) {
    return _dio!.transformer.transformRequest(options);
  }
}
