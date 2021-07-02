import 'package:example2/di/injector.dart';
import 'package:fa_flutter_api_client/fa_flutter_api_client.dart';
import 'package:flutter/material.dart';

import 'interceptor/logging_interceptor.dart';

class TestApiPage extends StatefulWidget {
  @override
  _TestApiPageState createState() => _TestApiPageState();
}

class _TestApiPageState extends State<TestApiPage> {
  bool _isLoading = true;
  String? _data;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api Client'),
      ),
      body: Center(
        child: _isLoading ? CircularProgressIndicator() : Text(_data!),
      ),
    );
  }

  Future<void> _init() async {
    try {
      final response = await locator<ApiService>().get(
        url: 'https://jsonplaceholder.typicode.com/posts',
      );
      setState(() {
        _isLoading = false;
        _data = response.data?.toString();
      });
    } catch (e, s) {
      logger.e(e, s);
    }
  }
}
