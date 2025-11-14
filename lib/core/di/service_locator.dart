import 'package:get_it/get_it.dart';
import 'package:movieapp/core/config/environment.dart';
import 'package:movieapp/core/config/environment_detector.dart';
import 'package:movieapp/core/network/dio_network_client.dart';
import 'package:movieapp/core/network/network_client.dart';
import 'package:movieapp/core/network/network_inteceptor_manager.dart';
import 'package:movieapp/core/network/network_logger.dart';
import 'package:movieapp/core/network/network_error_handler.dart';
import 'package:movieapp/core/network/network_response_factory.dart';
import 'package:movieapp/features/movies/di/movie_service_locator.dart';

final GetIt sl = GetIt.instance;

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._();
  ServiceLocator._();

  static Future<void> init() async {
    await _instance._registerEnvironment();
    await _instance._registerNetworkInfrastructure();
    await _instance._registerNetworkClient();
    await _instance._registerMovieFeature();
  }

  Future<void> _registerEnvironment() async {
    final environment = EnvironmentDetector.detectEnvironment();
    sl.registerLazySingleton<Environment>(() => environment);
  }

  Future<void> _registerNetworkInfrastructure() async {
    sl.registerLazySingleton<NetworkLogger>(() => ConsoleNetworkLogger());
    sl.registerLazySingleton<NetworkErrorHandler>(() => DioErrorHandler());
    sl.registerLazySingleton<NetworkResponseFactory>(
      () => DefaultNetworkResponseFactory(),
    );
    sl.registerLazySingleton<NetworkInterceptorManager>(
      () => LoggingInterceptorManager(logger: sl()),
    );
  }

  Future<void> _registerNetworkClient() async {
    sl.registerLazySingleton<NetworkClient>(
      () => DioNetworkClient(
        config: sl<Environment>(),
        logger: sl<NetworkLogger>(),
        errorHandler: sl<NetworkErrorHandler>(),
        responseFactory: sl<NetworkResponseFactory>(),
        interceptorManager: sl<NetworkInterceptorManager>(),
      ),
    );
  }

  Future<void> _registerMovieFeature() async {
    await MovieServiceLocator.init();
  }
}
