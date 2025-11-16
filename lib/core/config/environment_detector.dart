import 'package:flutter/foundation.dart';
import 'package:movieapp/core/config/environment_type.dart';
import 'package:movieapp/core/config/environment_factory.dart';
import 'package:movieapp/core/config/environment.dart';

class EnvironmentDetector {
  final Environment _environment;

  EnvironmentDetector({EnvironmentFactory? factory})
    : _environment = _detectEnvironment(factory ?? EnvironmentFactory());

  Environment get environment => _environment;

  static Environment _detectEnvironment(EnvironmentFactory factory) {
    final dartDefineEnv = _getFromDartDefines(factory);
    if (dartDefineEnv != null) {
      if (kDebugMode) {
        print(
          'Environment detected from Dart defines: ${dartDefineEnv.type.title}',
        );
      }
      return dartDefineEnv;
    }

    if (kDebugMode) {
      print(
        'No environment specified via --dart-define, defaulting to Development',
      );
    }
    return factory.createEnvironment(EnvironmentType.development);
  }

  static Environment? _getFromDartDefines(EnvironmentFactory factory) {
    try {
      const dartDefine = String.fromEnvironment('ENVIRONMENT');
      if (dartDefine.isNotEmpty) {
        return factory.createFromString(dartDefine);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error reading Dart defines: $e');
      }
    }
    return null;
  }

  void printEnvironmentInfo(Environment env) {
    if (kDebugMode) {
      print('''
  Movie App Environment Info:
  App: ${env.appName}
  Environment: ${env.type.title}
  Version: ${env.version}
  API: ${env.baseUrl}
  API Key: ${_maskApiKey(env.apiKey)}
  Logging: ${env.enableLogging}
  Source: Dart Defines (--dart-define)
''');
    }
  }

  String _maskApiKey(String apiKey) {
    if (apiKey.length <= 8) return '***';
    return '${apiKey.substring(0, 3)}...${apiKey.substring(apiKey.length - 3)}';
  }
}
