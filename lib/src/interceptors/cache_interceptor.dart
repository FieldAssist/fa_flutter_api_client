// ignore_for_file: cascade_invocations

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fa_flutter_core/fa_flutter_core.dart';

abstract class ApiCacheInterceptor extends Interceptor {
  ApiCacheInterceptor({required this.sembastAppDb});

  final SembastHelperImpl sembastAppDb;
  final AppLog logger = AppLogImpl();
  final cache_response_status = 1001;
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // try {
    final response = await _cacheResponse(options);

    if (response != null) {
      logger.v(
        '''************** 🚀  CACHE INTERCEPTOR - Returning cached data 🚀 *********''',
      );

      return handler.resolve(response, true);
    }

    logger.v(
      '''************** ⏳ CACHE INTERCEPTOR - FETCHING NETWORK DATA ⏳ *********''',
    );
    // } catch (e) {
    // logger.d('********  ❌ CACHE INTERCEPTOR - ERROR  ❌ $e ********');
    // }
    return handler.next(options);
  }

  Future<Response?> _cacheResponse(RequestOptions options) async {
    final _now = DateTime.now();
    final _midnightTime =
        DateTime(_now.year, _now.month, _now.day + 1).subtract(
      Duration(
        seconds: 1,
      ),
    );
    final _apiDataKey = _formStringFromRequestHeaders(options);
    final _storeRef = StoreRef.main();
    final keyData = await sembastAppDb.get(_storeRef.record(_apiDataKey))
        as Map<String, dynamic>?;

    if (keyData != null) {
      final isValid = isCacheValid(
        DateTime.parse(
          keyData['appSpecificHeaders']?['expirationTime'] ?? _midnightTime,
          DateTime.parse(
            keyData['appSpecificHeaders']?['cachedTime'],
          ),
        ),
      );
      if (isValid) {
        logger.v("**************  🔥 VALIDATING CACHE 🔥   ***********");
        return Response(
          requestOptions: options,
          data: jsonDecode(keyData['appSpecificHeaders']?['data'] ?? ''),
          statusCode: cache_response_status,
          redirects: [],
          extra: {},
          isRedirect: false,
          statusMessage: 'Cached Data',
        );
      } else {
        await sembastAppDb.delete(_storeRef.record(_apiDataKey));
      }
    }

    return null;
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    final res = await _cacheResponse(err.requestOptions);
    cacheInterceptorErrorHandler(err);
    if (res != null) {
      return handler.resolve(res);
    }

    return handler.next(err);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    await saveResponse(response);
    return handler.next(response);
  }

  Future<void> saveResponse(Response response) async {
    final _apiDataKey = _formStringFromRequestHeaders(response.requestOptions);

    final _now = DateTime.now();
    final _midnightTime =
        DateTime(_now.year, _now.month, _now.day + 1).subtract(
      Duration(
        seconds: 1,
      ),
    );
    final status = response.statusCode ?? 0;
    final cacheResponse =
        response.requestOptions.headers['cacheResponse'] ?? true;

    if ((status == 200 || status == 201 || status == 202) && cacheResponse) {
      log(response.requestOptions.headers.toString());
      //  await sembastHelper.put(sembastHelper.record(_dataStore, id), response);
      final _storeRef = StoreRef.main();

      await sembastAppDb.put(
        sembastAppDb.record(_storeRef, _apiDataKey),
        {
          'appSpecificHeaders': {
            "expirationTime": (response.requestOptions
                        .headers['appSpecificHeaders']['expirationTime'] ??
                    _midnightTime)
                .toString(),
            "cachedTime": DateTime.now().toString(),
            "data": jsonEncode(response.data),
            "status": cache_response_status
          }
        },
      );

      logger.v(
        '''************** ✅  CACHE INTERCEPTOR -> CACHED ✅ *********''',
      );
    }
  }

  String _formStringFromRequestHeaders(
    RequestOptions options,
  ) {
    final url = options.uri.toString().replaceFirst(options.baseUrl, '');
    final body = jsonEncode(options.data ?? {});
    final queryParams = jsonEncode(options.queryParameters);
    return '$url/$queryParams/$body';
  }

  bool isCacheValid(DateTime expirationTime, DateTime cacheTime) {
    if (cacheTime.isSameDate(DateTime.now()) &&
        DateTime.now().isBefore(expirationTime)) {
      return true;
    }

    return false;
  }

  void cacheInterceptorErrorHandler(DioError err);
}
