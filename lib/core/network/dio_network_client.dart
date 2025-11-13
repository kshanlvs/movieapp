import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movieapp/core/config/environment.dart';
import 'package:movieapp/core/network/network_client.dart';

class DioNetworkClient implements NetworkClient {
  final Dio _dio;
  final Environment config;

  DioNetworkClient(this.config)
      : _dio = Dio(
          BaseOptions(
            baseUrl: config.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${config.apiKey}',
            },
          ),
        ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  @override
  Future<NetworkResponse> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return NetworkResponse(
        statusCode: response.statusCode!,
        body: response.data is String ? response.data : json.encode(response.data),
        headers: response.headers.map.map((key, list) => MapEntry(key, list.first)),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<NetworkResponse> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: body,
        options: Options(headers: headers),
      );
      return NetworkResponse(
        statusCode: response.statusCode!,
        body: response.data is String ? response.data : json.encode(response.data),
        headers: response.headers.map.map((key, list) => MapEntry(key, list.first)),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<NetworkResponse> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      final response = await _dio.put(
        url,
        data: body,
        options: Options(headers: headers),
      );
      return NetworkResponse(
        statusCode: response.statusCode!,
        body: response.data is String ? response.data : json.encode(response.data),
        headers: response.headers.map.map((key, list) => MapEntry(key, list.first)),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<NetworkResponse> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        url,
        options: Options(headers: headers),
      );
      return NetworkResponse(
        statusCode: response.statusCode!,
        body: response.data is String ? response.data : json.encode(response.data),
        headers: response.headers.map.map((key, list) => MapEntry(key, list.first)),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  void setBaseHeaders(Map<String, String> headers) {
    _dio.options.headers.addAll(headers);
  }

  @override
  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  @override
  void setTimeout(Duration timeout) {
    _dio.options.connectTimeout = timeout;
    _dio.options.receiveTimeout = timeout;
  }

  NetworkException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutNetworkException('Request timeout', url: error.requestOptions.path);
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
        return NetworkException('Request cancelled', url: error.requestOptions.path);
      case DioExceptionType.unknown:
        return NetworkException('Unknown error: ${error.message}', url: error.requestOptions.path);
      case DioExceptionType.badCertificate:
        return NetworkException('Bad certificate', url: error.requestOptions.path);
      case DioExceptionType.connectionError:
        return NetworkException('Connection error', url: error.requestOptions.path);
    }
  }
}