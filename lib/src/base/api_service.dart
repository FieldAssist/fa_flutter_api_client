import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../api_options/api_options.dart';

abstract class ApiService {
  Future<Response<T>> get<T>({
    String? endpoint,
    String? url,
    ApiOptions? options,
  });

  Future<Response<T>> post<T>({
    String? url,
    String? endpoint,
    String? body,
    ApiOptions? options,
  });

  Future<Response<T>> put<T>({
    String? endpoint,
    String? body,
    ApiOptions? options,
  });

  Future<Response<T>> delete<T>({
    String? endpoint,
    ApiOptions? options,
  });

  Future<Response<T>> postFile<T>({
    bool isJsonEncode = true,
    String? endpoint,
    String? url,
    String? keyName,
    File? file,
    ProgressCallback? onSendProgress,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? dataParameters,
    String? dataKeyName,
  });

  void setBaseUrl(String baseUrl);

  String getBaseUrl();

  String getFileUploadUrl();

  Dio? getDioFile();

  Dio? getApiClient();

  /// get key for disabling auth for some requests.
  String getIsAuthRequiredKey();

  Future<String> requestTranformer(RequestOptions options);
}
