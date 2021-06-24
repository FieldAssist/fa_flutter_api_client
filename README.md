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

To use 'exceptions.dart' present in this package, add a widget to your project (preferrably called 'stream_error_widget' and copy the following code to the same dart file:

```
import 'package:fa_flutter_ui_kit/fa_flutter_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';

class StreamErrorWidget extends StatelessWidget {
  const StreamErrorWidget(
      this.streamError,
      this.onTap,
      );

  final dynamic streamError;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getWidget(),
          ],
        ),
      ),
    );
  }

  Widget getWidget() {
    if (streamError is NoInternetError) {
      return InternetNotAvailable(onTap);
    } else if (streamError is ClientError ||
        streamError is ServerError) {
      return ServerErrorWidget(streamError.toString(), onTap);
    } else if (streamError is LocationException) {
      return LocationErrorWidget(
          error: streamError.toString(), onRefreshTap: onTap);
    } else {
      return UnknownErrorWidget(
        onTap,
        message: streamError?.toString() ?? Constants.errorSomethingWentWrong,
      );
    }
  }
}
```

Further, to use this error widget, replace it wherever errors are to be displayed in your application.
