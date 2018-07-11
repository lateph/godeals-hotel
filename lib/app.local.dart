import 'package:dio/dio.dart';

class App {
  final String name = 'AksaraPay';
  final String version = '0.0.1';

  final String baseUrl = 'http://188.166.180.89/godeals/api/web';
  final Map<String, String> defaultHeaders = {
    'X-App-key': 'GoDealsDevelopmentAppKey',
    'X-App-secret': 'GoDealsDevelopmentAppSecret',
    'X-Device-identifier': 'DI-DEV-10001',
    'Content-Type': 'application/json'
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
