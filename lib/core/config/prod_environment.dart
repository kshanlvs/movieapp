import 'environment.dart';
import 'environment_type.dart';

class ProdEnvironment implements Environment {
  @override
  EnvironmentType get type => EnvironmentType.production;
  
  @override
  String get baseUrl => 'https://api.themoviedb.org/3';
  
  @override
  String get apiKey => const String.fromEnvironment(
    'API_KEY',
    defaultValue: 'your_prod_api_key_here'
  );
  
  @override
  bool get enableLogging => false;
  
  @override
  String get version => '1.0.0';
  
  @override
  String get appName => const String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Movie App'
  );
}