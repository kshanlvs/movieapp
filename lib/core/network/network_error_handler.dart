import 'package:dio/dio.dart';
import 'package:movieapp/core/network/network_client.dart';

abstract class NetworkErrorHandler {
  NetworkException handleDioError(DioException error);
}

class DioErrorHandler implements NetworkErrorHandler {
  @override
  NetworkException handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutNetworkException(
          'Request timeout',
          url: error.requestOptions.path,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return UnauthorizedNetworkException(url: error.requestOptions.path);
        }
        return NetworkException(
          'HTTP $statusCode: ${error.response?.statusMessage}',
          statusCode: statusCode,
          url: error.requestOptions.path,
        );
      case DioExceptionType.cancel:
        return NetworkException(
          'Request cancelled',
          url: error.requestOptions.path,
        );
      case DioExceptionType.unknown:
        return NetworkException(
          'Unknown error: ${error.message}',
          url: error.requestOptions.path,
        );
      case DioExceptionType.badCertificate:
        return NetworkException(
          'Bad certificate',
          url: error.requestOptions.path,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          'Connection error',
          url: error.requestOptions.path,
        );
    }
  }
}
