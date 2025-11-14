import 'package:dio/dio.dart';
import 'package:movieapp/core/network/network_logger.dart';

abstract class NetworkInterceptorManager {
  void setupInterceptors(Dio dio);
}

class LoggingInterceptorManager implements NetworkInterceptorManager {
  final NetworkLogger logger;

  LoggingInterceptorManager({required this.logger});

  @override
  void setupInterceptors(Dio dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.logRequest(options);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.logResponse(response);
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          logger.logError(error);
          return handler.next(error);
        },
      ),
    );
  }
}
