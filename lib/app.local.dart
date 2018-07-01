import 'package:dio/dio.dart';

class App {
  final String name = 'AksaraPay';
  final String version = '0.0.1';

  final String baseUrl = 'http://msa.server-development.net/api/v2/web';
  final Map<String, String> defaultHeaders = {
//    'X-App-key': 'EzyCashAppsDevKey',
//    'X-App-secret': 'EzyCashAppsDevSecret',
    'Accept': 'application/json'
  };

  // http client
  Dio api;

  App() {
    api = Dio(
      Options(
        baseUrl: baseUrl,
        headers: defaultHeaders,
        connectTimeout: 5000,
      ),
    );
  }
}
