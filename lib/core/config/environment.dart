import 'package:movieapp/core/config/environment_type.dart';

abstract class Environment {
  EnvironmentType get type;
  String get baseUrl;
  String get apiKey;
  bool get enableLogging;
  String get version;
  String get appName;
}

class AppEnvironment {
  static final AppEnvironment _instance = AppEnvironment._internal();
  factory AppEnvironment() => _instance;
  AppEnvironment._internal();

  late Environment _environment;

  Environment get current => _environment;

  EnvironmentType get currentType => _environment.type;

  void setEnvironment(Environment env) {
    _environment = env;
  }

  bool get isDevelopment => currentType.isDevelopment;
  bool get isStaging => currentType.isStaging;
  bool get isProduction => currentType.isProduction;
}
