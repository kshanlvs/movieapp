enum EnvironmentType {
  development('dev', 'Development'),
  staging('staging', 'Staging'),
  production('prod', 'Production');

  const EnvironmentType(this.value, this.title);

  final String value;
  final String title;

  static EnvironmentType fromString(String value) {
    return EnvironmentType.values.firstWhere(
      (env) => env.value == value,
      orElse: () => EnvironmentType.development,
    );
  }

  bool get isDevelopment => this == EnvironmentType.development;
  bool get isStaging => this == EnvironmentType.staging;
  bool get isProduction => this == EnvironmentType.production;
}
