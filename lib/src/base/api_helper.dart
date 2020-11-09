import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

abstract class ApiHelper {
  Future<Response<T>> get<T>({
    String endpoint,
    String url,
  });

  Future<Response<T>> post<T>({String endpoint, String body});

  Future<Response<T>> put<T>({String endpoint, String body});

  Future<Response<T>> delete<T>({String endpoint});

  Future<Response<T>> postFile<T>({File file});

  void setBaseUrl(String baseUrl);

  String getBaseUrl();

  String getFileUploadUrl();

  Dio getDioFile();
}
