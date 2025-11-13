import 'environment_type.dart';

abstract class Environment {
  EnvironmentType get type;
  String get baseUrl;
  String get apiKey;
  bool get enableLogging;
  String get version;
  String get appName;
}

class AppEnvironment {
  static late Environment _environment;
  
  static Environment get current => _environment;
  
  static EnvironmentType get currentType => _environment.type;
  
  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static bool get isDevelopment => currentType.isDevelopment;
  static bool get isStaging => currentType.isStaging;
  static bool get isProduction => currentType.isProduction;
}