# fa_flutter_api_client [![codecov](https://codecov.io/gh/FieldAssist/fa_flutter_firebase/branch/main/graph/badge.svg?token=DUR835BOVX)](https://codecov.io/gh/FieldAssist/fa_flutter_firebase)

Official FA Flutter API client package.

## Getting Started

Add following code in `pubspec.yaml` file in `dependencies`:

```
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
