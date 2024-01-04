import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../api_options/api_options.dart';

abstract class ApiService {
  Future<Response<T>> get<T>({
    String? endpoint,
    String? url,
    ApiOptions? options,
    CancelToken? cancelToken,
  });

  Future<Response<T>> post<T>({
    String? url,
    String? endpoint,
    String? body,
    ApiOptions? options,
    CancelToken? cancelToken,
  });

  Future<Response<T>> put<T>({
    String? endpoint,
    String? body,
    ApiOptions? options,
    CancelToken? cancelToken,
  });

  Future<Response<T>> delete<T>({
    String? endpoint,
    ApiOptions? options,
    CancelToken? cancelToken,
  });

  Future<Response<T>> postFile<T>({
    String? endpoint,
    String? keyName,
    File? file,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  });

  void setBaseUrl(String baseUrl);

  String getBaseUrl();

  String getFileUploadUrl();

  Dio? getDioFile();

  Dio? getApiClient();

  /// get key for disabling auth for some requests.
  String getIsAuthRequiredKey();
}
