import 'dart:convert';
import 'package:dio/dio.dart';

abstract class NetworkLogger {
  void logRequest(RequestOptions options);
  void logResponse(Response response);
  void logError(DioException error);
}

class ConsoleNetworkLogger implements NetworkLogger {
  @override
  void logRequest(RequestOptions options) {
    print('=== NETWORK REQUEST ===');
    print('METHOD: ${options.method}');
    print('URL: ${options.uri}');
    print('Headers: ${options.headers}');
    if (options.queryParameters.isNotEmpty) {
      print('Query Params: ${options.queryParameters}');
    }
    if (options.data != null) {
      print('Body: ${options.data}');
    }
    print('=======================');
  }

  @override
  void logResponse(Response response) {
    print('=== NETWORK RESPONSE ===');
    print('URL: ${response.requestOptions.uri}');
    print('Status: ${response.statusCode}');

    final responseBody = response.data is String
        ? response.data
        : json.encode(response.data);
    final truncatedBody = responseBody.length > 500
        ? '${responseBody.substring(0, 500)}...'
        : responseBody;
    print('Body: $truncatedBody');
    print('=========================');
  }

  @override
  void logError(DioException error) {
    print('=== NETWORK ERROR ===');
    print('URL: ${error.requestOptions.uri}');
    print('Method: ${error.requestOptions.method}');
    print('Error Type: ${error.type}');
    print('Message: ${error.message}');

    if (error.response != null) {
      print('Status Code: ${error.response?.statusCode}');
      print('Response Data: ${error.response?.data}');
    }
    print('====================');
  }
}
