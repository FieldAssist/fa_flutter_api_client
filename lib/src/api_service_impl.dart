import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fa_flutter_core/fa_flutter_core.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

import 'base/api_service.dart';
import 'exceptions/errors.dart';
import 'exceptions/exceptions.dart';
import 'utils/mime_type.dart';

class ApiServiceImpl implements ApiService {
  ApiServiceImpl({
    @required this.baseUrl,
    this.interceptors,
  }) {
    _dio = Dio()..options.contentType = Headers.jsonContentType;

    if (interceptors != null && interceptors.isNotEmpty) {
      _dio.interceptors.addAll(interceptors);
    }

    _dioFile = Dio()
      ..options.connectTimeout = 60000
      ..options.receiveTimeout = 300000;

    if (interceptors != null && interceptors.isNotEmpty) {
      _dioFile.interceptors.addAll(interceptors);
    }
  }

  String baseUrl;
  Dio _dio;

  Dio _dioFile;

  final List<Interceptor> interceptors;

  @override
  Future<Response<T>> get<T>({
    String endpoint,
    String url,
  }) async {
    try {
      if (checkIfNotEmpty(url)) {
        return await _dio.get<T>('$url');
      }
      return await _dio.get<T>('$baseUrl$endpoint');
    } on ClientError catch (e, s) {
      throw ClientException(
        statusCode: e.response.statusCode,
        msg: e.response.data ?? e.response.statusMessage,
      );
    } on UnauthorizedError {
      throw UnauthorizedException();
    } on ServerError catch (e, s) {
      throw ServerException(e.toString());
    } on NoInternetError {
      throw NoInternetException();
    } on UnknownError catch (e, s) {
      throw UnknownException('Oops! Something went wrong.\n\n${e.toString()}');
    }
  }

  @override
  Future<Response<T>> post<T>({String endpoint, String body}) async {
    try {
      return await _dio.post<T>('$baseUrl$endpoint', data: body);
    } on ClientError catch (e, s) {
      throw ClientException(
        statusCode: e.response.statusCode,
        msg: e.response.data ?? e.response.statusMessage,
      );
    } on UnauthorizedError {
      throw UnauthorizedException();
    } on ServerError catch (e, s) {
      throw ServerException(e.toString());
    } on NoInternetError {
      throw NoInternetException();
    } on UnknownError catch (e, s) {
      throw UnknownException('Oops! Something went wrong.\n\n${e.toString()}');
    }
  }

  @override
  Future<Response<T>> delete<T>({String endpoint}) async {
    try {
      return await _dio.delete<T>('$baseUrl$endpoint');
    } on ClientError catch (e, s) {
      throw ClientException(
        statusCode: e.response.statusCode,
        msg: e.response.data ?? e.response.statusMessage,
      );
    } on UnauthorizedError {
      throw UnauthorizedException();
    } on ServerError catch (e, s) {
      throw ServerException(e.toString());
    } on NoInternetError {
      throw NoInternetException();
    } on UnknownError catch (e, s) {
      throw UnknownException('Oops! Something went wrong.\n\n${e.toString()}');
    }
  }

  @override
  Future<Response<T>> put<T>({String endpoint, String body}) async {
    try {
      return await _dio.put<T>('$baseUrl$endpoint', data: body);
    } on ClientError catch (e, s) {
      throw ClientException(
        statusCode: e.response.statusCode,
        msg: e.response.data ?? e.response.statusMessage,
      );
    } on UnauthorizedError {
      throw UnauthorizedException();
    } on ServerError catch (e, s) {
      throw ServerException(e.toString());
    } on NoInternetError {
      throw NoInternetException();
    } on UnknownError catch (e, s) {
      throw UnknownException('Oops! Something went wrong.\n\n${e.toString()}');
    }
  }

  @override
  Future<Response<T>> postFile<T>({File file}) async {
    try {
      if (file == null) {
        throw const MyException("Attached file is null");
      }
      final fileName = basename(file.path);
      var mimeType = mime(fileName);
      mimeType ??= 'application/octet-stream';
      final type = mimeType.split('/')[0];
      final subType = mimeType.split('/')[1];
      final formData = FormData.fromMap({
        'asset': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType(type, subType),
        ),
      });
      return await _dioFile.post(
        getFileUploadUrl(),
        data: formData,
      );
    } on ClientError catch (e, s) {
      throw ClientException(
        statusCode: e.response.statusCode,
        msg: e.response.data ?? e.response.statusMessage,
      );
    } on UnauthorizedError {
      throw UnauthorizedException();
    } on ServerError catch (e, s) {
      throw ServerException(e.toString());
    } on NoInternetError {
      throw NoInternetException();
    } on UnknownError catch (e, s) {
      throw UnknownException('Oops! Something went wrong.\n\n${e.toString()}');
    }
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
  Dio getDioFile() {
    return _dioFile;
  }

  @override
  Dio getApiClient() {
    return _dio;
  }
}
