import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../api_options/api_options.dart';

abstract class ApiService {
  Future<Response<T>> get<T>({
    String? endpoint,
    String? url,
    String? body,
    ApiOptions? options,
  });

  Future<Response<T>> post<T>({
    String? url,
    String? endpoint,
    String? body,
    ApiOptions? options,
    bool isRefreshTokenRequest = false,
  });

  Future<Response<T>> put<T>({
    String? endpoint,
    String? body,
    ApiOptions? options,
  });

  Future<Response<T>> delete<T>({String? endpoint, ApiOptions? options});

  Future<Response<T>> patch<T>({
    String? endpoint,
    String? body,
    ApiOptions? options,
  });

  Future<Response<T>> postFile<T>({
    String? endpoint,
    String? url,
    String? keyName,
    File? file,
    ApiOptions? options,
    ProgressCallback? onSendProgress,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? dataParameters,
  });

  Future<Response<T>> putFile<T>({
    String? endpoint,
    String? url,
    String? keyName,
    File? file,
    ApiOptions? options,
    ProgressCallback? onSendProgress,
    Map<String, dynamic>? queryParameters,
});

  void setBaseUrl(String baseUrl);

  String getBaseUrl();

  void setBlobUrl(String blobUrl);

  String getBlobUrl(String path);

  String getFileUploadUrl();

  Dio? getDioFile();

  Dio? getApiClient();

  Dio? getRefreshTokenApiClient();

  /// get key for disabling auth for some requests.
  String getIsAuthRequiredKey();

  Future<String> requestTranformer(RequestOptions options);
}
