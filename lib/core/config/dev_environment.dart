import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'environment.dart';
import 'environment_type.dart';

class DevEnvironment implements Environment {
  @override
  EnvironmentType get type => EnvironmentType.development;

  @override
  String get baseUrl => 'https://api.themoviedb.org/3';

  @override
  String get apiKey => dotenv.get('API_KEY');

  @override
  bool get enableLogging => true;

  @override
  String get version => '1.0.0-dev';

  @override
  String get appName =>
      const String.fromEnvironment('APP_NAME', defaultValue: 'Movie App Dev');
}
