import 'package:flutter/foundation.dart';

import 'environment_type.dart';
import 'environment_factory.dart';
import 'environment.dart';

class EnvironmentDetector {
  static Environment detectEnvironment() {
    final dartDefineEnv = _getFromDartDefines();
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
    return EnvironmentFactory.createEnvironment(EnvironmentType.development);
  }

  static Environment? _getFromDartDefines() {
    try {
      const dartDefine = String.fromEnvironment('ENVIRONMENT');
      if (dartDefine.isNotEmpty) {
        return EnvironmentFactory.createFromString(dartDefine);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error reading Dart defines: $e');
      }
    }
    return null;
  }

  static void printEnvironmentInfo() {
    final env = AppEnvironment.current;
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

  static String _maskApiKey(String apiKey) {
    if (apiKey.length <= 8) return '***';
    return '${apiKey.substring(0, 3)}...${apiKey.substring(apiKey.length - 3)}';
  }
}
