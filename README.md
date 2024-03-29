# fa_flutter_api_client [![codecov](https://codecov.io/gh/FieldAssist/fa_flutter_firebase/branch/main/graph/badge.svg?token=DUR835BOVX)](https://codecov.io/gh/FieldAssist/fa_flutter_firebase)

Official FA Flutter API client package.

## Getting Started

Add following code in `pubspec.yaml` file in `dependencies`:

``` yaml
  fa_flutter_api_client:
    git:
      url: https://github.com/FieldAssist/fa_flutter_api_client.git
      ref: main
```

## Migration Guide

All of the following exceptions defined in exceptions in this package have been renamed to errors as follows:

1. `ServerException` -> `ServerError`
2. `UnauthorizedException` -> `UnauthorizedError`
3. `UnauthenticatedException` -> `UnauthenticatedError`
4. `UnknownApiException` -> `UnknownApiError`
5. `NoInternetException` -> `NoInternetError`
6. `UnstableInternetException` -> `UnstableInternetError`

## Introduction and Usage

fa_flutter_api_client is a customised implementation of api_client. It serves as a base for other
FieldAssist apps. This package is used to implemented Dio effortlessly into other FieldAssist apps.

The basic functionalities that this package offers are:-

1. Error Logging:- It logs any error that happens in the API during its run. It does so using the
   logger.

2. Network Error Interception:- Whenever the network is unavailable, the error is intercepted, and
   the red screen of error is avoided on the device.

3. Authentication Token Error Interception:- Similarly to the network error interception, this one
   intercepts the error whenever the token is missing for an API call.

## Example

AuthInterceptor

```dart
import 'package:dio/dio.dart';
import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';
import 'package:fa_flutter_gt/data/contract/user_repository.dart';
import 'package:fa_flutter_gt/di/injector.dart';

class MyAuthInterceptor extends AuthInterceptor {
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = locator<UserRepository>().authToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}
```
ErrorInterceptor
```dart
import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';

class MyErrorInterceptor extends ErrorInterceptor {
  //TODO(Aashishm178):Handle unAuthorize
}
```
NetworkInterceptor
```dart
import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';
import 'package:fa_flutter_core/fa_flutter_core.dart';
import 'package:fa_flutter_gt/core/network/network_info.dart';

class MyNetworkInterceptor extends NetworkInterceptor {
  MyNetworkInterceptor(this.networkInfo);

  final NetworkInfo? networkInfo;

  @override
  Future<bool> isInternetConnected() async {
    if (isWeb) {
      return true;
    }

    return networkInfo!.isConnected;
  }
}
```
## Usage

Make a directory in lib folder called di and add a file name injector.dart
``` dart
import 'package:example2/interceptor/auth_interceptor.dart';
import 'package:example2/interceptor/logging_interceptor.dart';
import 'package:example2/interceptor/network/network_info.dart';
import 'package:example2/interceptor/network_interceptor.dart';
import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

const _debugBaseUrl = 'https://fa-maapins-debug.fieldassist.io/api/';

final locator = GetIt.instance;

class Injector {
  Future<void> init() async {
    locator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(
        connectionChecker: InternetConnectionChecker(),
      ),
    );

    final interceptors = [
      MyNetworkInterceptor(networkInfo: locator()),
      MyAuthInterceptor(),
      ErrorInterceptor(),
      MyLoggingInterceptor(),
    ];
    locator.registerLazySingleton<ApiService>(() {
      return ApiServiceImpl(
        baseUrl: _debugBaseUrl,
        interceptors: interceptors,
      );
    });
  }
}
```

After doing this you can call your API URL using the locator and ApiService

For exmple:-
```
  final response = await locator<ApiService>().get(
        url: 'https://jsonplaceholer.typicode.com/posts',
      );
```
