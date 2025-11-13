import 'environment.dart';
import 'environment_type.dart';

class StagingEnvironment implements Environment {
  @override
  EnvironmentType get type => EnvironmentType.staging;
  
  @override
  String get baseUrl => 'https://api.themoviedb.org/3';
  
  @override
  String get apiKey => const String.fromEnvironment(
    'API_KEY',
    defaultValue: 'your_staging_api_key_here'
  );
  
  @override
  bool get enableLogging => true;
  
  @override
  String get version => '1.0.0-staging';
  
  @override
  String get appName => const String.fromEnvironment(
    'APP_NAME', 
    defaultValue: 'Movie App Staging'
  );
}