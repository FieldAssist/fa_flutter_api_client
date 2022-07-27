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

  Future<Response<T>> postFile<T>(
      {File? file, ProgressCallback? onSendProgress});

  void setBaseUrl(String baseUrl);

  String getBaseUrl();

  String getFileUploadUrl();

  Dio? getDioFile();

  Dio? getApiClient();

  /// get key for disabling auth for some requests.
  String getIsAuthRequiredKey();
}
