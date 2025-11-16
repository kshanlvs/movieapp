import 'package:movieapp/core/config/environment.dart';
import 'package:movieapp/core/config/environment_type.dart';
import 'package:movieapp/core/config/dev_environment.dart';
import 'package:movieapp/core/config/staging_environment.dart';
import 'package:movieapp/core/config/prod_environment.dart';

class EnvironmentFactory {
  Environment createEnvironment(EnvironmentType type) {
    switch (type) {
      case EnvironmentType.development:
        return DevEnvironment();
      case EnvironmentType.staging:
        return StagingEnvironment();
      case EnvironmentType.production:
        return ProdEnvironment();
    }
  }

  Environment createFromString(String envString) {
    final type = EnvironmentType.fromString(envString);
    return createEnvironment(type);
  }
}
