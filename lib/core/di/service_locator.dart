import 'package:get_it/get_it.dart';
import 'package:movieapp/core/config/environment.dart';
import 'package:movieapp/core/config/environment_detector.dart';
import 'package:movieapp/core/network/dio_network_client.dart';
import 'package:movieapp/core/network/network_client.dart';

final GetIt sl = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    await _registerEnvironment();
    await _registerNetworkClient();
  }

  static Future<void> _registerEnvironment() async {
    final environment = EnvironmentDetector.detectEnvironment();
    sl.registerLazySingleton<Environment>(() => environment);
  }
  
  static Future<void> _registerNetworkClient() async {
  
    sl.registerLazySingleton<NetworkClient>(() => DioNetworkClient(sl<Environment>()));
  }
}