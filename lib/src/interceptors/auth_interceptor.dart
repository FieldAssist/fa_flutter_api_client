/*
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:trust_fall/trust_fall.dart';
import 'package:workozy_app/core/log/src/log_utils.dart';
import 'package:workozy_app/data/repository/base/user_repository.dart';
import 'package:workozy_app/di/injector.dart';
import 'package:workozy_app/utils/device_utils.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor()
  @override
  Future onRequest(RequestOptions options) async {
    if (injector<UserRepository>().authToken != null) {
      final token = injector<UserRepository>().authToken;
      options.headers['Authorization'] = 'Bearer $token';
    }
    if (kIsWeb) {
      options.headers['sender'] = 'web';
    } else if (Platform.isLinux) {
      options.headers['sender'] = Platform.operatingSystem;
    } else if (Platform.isMacOS) {
      options.headers['sender'] = Platform.operatingSystem;
    } else if (isMobile) {
      final appVersion = await getBuildNumber();
      final buildVersion = await getBuildVersion();
      final packageName = await getPackageName();
      options.headers['app_version'] = appVersion;
      options.headers['build_number'] = appVersion;
      options.headers['build_version'] = buildVersion;
      options.headers['package_name'] = packageName;
      if (Platform.isAndroid) {
        options.headers['sender'] = Platform.operatingSystem;
      } else if (Platform.isIOS) {
        options.headers['sender'] = 'ios';
      } else {
        options.headers['sender'] = 'unknown mobile os';
      }
      try {
        final isRooted = await TrustFall.isJailBroken;
        final isRealDevice = await TrustFall.isRealDevice;
        options.headers['is_rooted'] = isRooted ?? false;
        options.headers['is_real_device'] = isRealDevice ?? false;
      } catch (e, s) {
        logger.e(e, s);
      }
    } else {
      options.headers['sender'] = 'unknown';
    }
    return options;
  }
}
*/
import 'package:dio/dio.dart';

abstract class AuthInterceptor extends Interceptor {}
