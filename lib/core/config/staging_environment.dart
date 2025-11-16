import 'package:movieapp/core/config/environment.dart';
import 'package:movieapp/core/config/environment_type.dart';

class StagingEnvironment implements Environment {
  @override
  EnvironmentType get type => EnvironmentType.staging;

  @override
  String get baseUrl => 'https://api.themoviedb.org/3';

  //Todo: make .env.stage and set apiKey
  @override
  String get apiKey => "";

  @override
  bool get enableLogging => true;

  @override
  String get version => '1.0.0-staging';

  @override
  String get appName => const String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Movie App Staging',
  );
}
