import 'environment.dart';
import 'environment_type.dart';
import 'dev_environment.dart';
import 'staging_environment.dart';
import 'prod_environment.dart';

class EnvironmentFactory {
  static Environment createEnvironment(EnvironmentType type) {
    switch (type) {
      case EnvironmentType.development:
        return DevEnvironment();
      case EnvironmentType.staging:
        return StagingEnvironment();
      case EnvironmentType.production:
        return ProdEnvironment();
    }
  }

  static Environment createFromString(String envString) {
    final type = EnvironmentType.fromString(envString);
    return createEnvironment(type);
  }
}
