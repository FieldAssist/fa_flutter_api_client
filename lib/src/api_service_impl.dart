import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fa_flutter_api_client/src/api_options/api_options.dart';
import 'package:fa_flutter_api_client/src/utils/constants.dart';
import 'package:fa_flutter_core/fa_flutter_core.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

import 'base/api_service.dart';

class ApiServiceImpl implements ApiService {
  ApiServiceImpl({
    required this.baseUrl,
    this.interceptors,
  }) {
    _dio = Dio()..options.contentType = Headers.jsonContentType;

    if (interceptors != null && interceptors!.isNotEmpty) {
      _dio!.interceptors.addAll(interceptors!);
    }

    _dioFile = Dio()
      ..options.connectTimeout = 60000
      ..options.receiveTimeout = 300000;

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
        options: Options(
          headers: _formatHeaders(options),
          receiveTimeout: options?.receiveTimeout,
          sendTimeout: options?.sendTimeout,
        ));
  }

  @override
  Future<Response<T>> post<T>({
    String? endpoint,
    String? body,
    ApiOptions? options,
  }) async {
    return _dio!.post<T>('$baseUrl$endpoint',
        data: body,
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
    String? keyName,
    File? file,
    ProgressCallback? onSendProgress,
  }) async {
    endpoint = endpoint != null ? "$baseUrl$endpoint" : getFileUploadUrl();
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
      "expirationTime": _midnightTime.toString()
    };
    return headers;
  }
}
