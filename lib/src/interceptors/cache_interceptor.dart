// ignore_for_file: cascade_invocations

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fa_flutter_core/fa_flutter_core.dart';

class ApiCacheInterceptor extends Interceptor {
  ApiCacheInterceptor({required this.sembastAppDb});

  final SembastHelperImpl sembastAppDb;
  final AppLog logger = AppLogImpl();
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final _now = DateTime.now();
    final _midnightTime =
        DateTime(_now.year, _now.month, _now.day + 1).subtract(
      Duration(
        seconds: 1,
      ),
    );
    try {
      logger.v("**************  CACHE INTERCEPTOR -> REQUEST *********");

      if (!(options.headers['appSpecificHeaders']?['forceRefreshCache'] ??
          false)) {
        final _apiDataKey = _formStringFromRequestHeaders(options);
//         final _data =
//             await sembastHelper.get(sembastHelper.record(_dataStore, id));
// final appDb = sembastAppDb.
        final _storeRef = StoreRef.main();
        final keyData = await sembastAppDb.get(_storeRef.record(_apiDataKey));
        if (keyData != null) {
          logger.v("**************  🔥 VALIDATING CACHE 🔥   ***********");

          /// If cache is valid
          if (isCacheValid(
            DateTime.parse(
              keyData['appSpecificHeaders']?['expirationTime'] ?? _midnightTime,
            ),
          )) {
            logger.v(
              '''************** 🚀  CACHE INTERCEPTOR -> Returning cached data 🚀 *********''',
            );

            return handler.resolve(
              Response(
                requestOptions: options,
                data: jsonDecode(keyData['appSpecificHeaders']?['data'] ?? ''),
                statusCode: 200,
                redirects: [],
                extra: {},
                isRedirect: false,
                statusMessage: 'Cached Data',
              ),
              true,
            );
          }
        } else {
          /// If cache has expired
          logger.v(
            '''************** ⏳  CACHE INTERCEPTOR - DATA EXPIRED, RE-FETCHING ⏳ *********''',
          );

          await sembastAppDb.delete(_storeRef.record(_apiDataKey));
          // await sembastAppDb.   .removeApiCache(_apiDataKey);
        }
      }
      logger.v(
        '''************** ⏳ CACHE INTERCEPTOR - FETCHING NETWORK DATA ⏳ *********''',
      );
      return handler.next(options);
    } catch (e) {
      logger.d('~~~~Error from cache interceptor: $e');
    }
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final _apiDataKey = _formStringFromRequestHeaders(response.requestOptions);
    logger.v("**************  CACHE INTERCEPTOR -> RESPONSE *********");
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
            "data": jsonEncode(response.data)
          }
        },
      );

      logger.v(
        '''************** ✅  CACHE INTERCEPTOR -> CACHED ✅ *********''',
      );
    }
    return handler.next(response);
  }

  String _formStringFromRequestHeaders(
    RequestOptions options,
  ) {
    final url = options.uri.toString().replaceFirst(options.baseUrl, '');
    final body = jsonEncode(options.data ?? {});
    final queryParams = jsonEncode(options.queryParameters);
    return '$url/$queryParams/$body';
  }

  bool isCacheValid(DateTime expirationTime) {
    if (DateTime.now().isBefore(expirationTime)) {
      return true;
    }

    return false;
  }
}
