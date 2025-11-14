import 'package:dio/dio.dart';
import 'package:movieapp/core/config/environment.dart';
import 'package:movieapp/core/network/network_client.dart';
import 'package:movieapp/core/network/network_inteceptor_manager.dart';
import 'network_logger.dart';
import 'network_error_handler.dart';
import 'network_response_factory.dart';

class DioNetworkClient implements NetworkClient {
  final Dio _dio;
  final Environment config;
  final NetworkLogger logger;
  final NetworkErrorHandler _errorHandler;
  final NetworkResponseFactory _responseFactory;
  final NetworkInterceptorManager _interceptorManager;

  DioNetworkClient({
    required this.config,
    required this.logger,
    required NetworkErrorHandler errorHandler,
    required NetworkResponseFactory responseFactory,
    required NetworkInterceptorManager interceptorManager,
  }) : _errorHandler = errorHandler,
       _responseFactory = responseFactory,
       _interceptorManager = interceptorManager,
       _dio = Dio(
         BaseOptions(
           queryParameters: {"api_key": config.apiKey},
           baseUrl: config.baseUrl,
           connectTimeout: const Duration(seconds: 30),
           receiveTimeout: const Duration(seconds: 30),
           headers: {
             'Content-Type': 'application/json',
             'Accept': 'application/json',
           },
         ),
       ) {
    _interceptorManager.setupInterceptors(_dio);
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
      return _responseFactory.createFromDioResponse(response);
    } on DioException catch (e) {
      throw _errorHandler.handleDioError(e);
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
      return _responseFactory.createFromDioResponse(response);
    } on DioException catch (e) {
      throw _errorHandler.handleDioError(e);
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
      return _responseFactory.createFromDioResponse(response);
    } on DioException catch (e) {
      throw _errorHandler.handleDioError(e);
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
      return _responseFactory.createFromDioResponse(response);
    } on DioException catch (e) {
      throw _errorHandler.handleDioError(e);
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
}
