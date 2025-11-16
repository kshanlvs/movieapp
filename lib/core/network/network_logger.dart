import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';

abstract class NetworkLogger {
  void logRequest(RequestOptions options);
  void logResponse(Response response);
  void logError(DioException error);
}

class ConsoleNetworkLogger implements NetworkLogger {
  static const bool _isDebug = bool.fromEnvironment('DEBUG', defaultValue: false);

  @override
  void logRequest(RequestOptions options) {
    if (!_isDebug) return;
    
    developer.log(
      '🌐 NETWORK REQUEST',
      name: 'Network',
      time: DateTime.now(),
      error: {
        'method': options.method,
        'url': options.uri.toString(),
        'headers': options.headers,
        'queryParams': options.queryParameters,
        'body': options.data,
      },
    );
  }

  @override
  void logResponse(Response response) {
    if (!_isDebug) return;

    final responseBody = response.data is String
        ? response.data
        : json.encode(response.data);
    final truncatedBody = responseBody.length > 500
        ? '${responseBody.substring(0, 500)}...'
        : responseBody;

    developer.log(
      '✅ NETWORK RESPONSE',
      name: 'Network',
   
      time: DateTime.now(),
      error: {
        'url': response.requestOptions.uri.toString(),
        'statusCode': response.statusCode,
        'body': truncatedBody,
      },
    );
  }

  @override
  void logError(DioException error) {
    if (!_isDebug) return;

    developer.log(
      'NETWORK ERROR',
      name: 'Network',
    
      time: DateTime.now(),
      error: {
        'url': error.requestOptions.uri.toString(),
        'method': error.requestOptions.method,
        'errorType': error.type.toString(),
        'message': error.message,
        'statusCode': error.response?.statusCode,
        'responseData': error.response?.data,
      },
    );
  }
}