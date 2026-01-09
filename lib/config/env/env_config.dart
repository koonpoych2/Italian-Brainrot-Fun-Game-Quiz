/// Environment types for the application
enum Environment { dev, staging, prod }

/// Base configuration class that holds all environment-specific values
abstract class EnvConfig {
  const EnvConfig();

  /// Current environment
  Environment get environment;

  /// Application name
  String get appName;

  /// Whether to enable logging
  bool get enableLogging;

  /// Whether to enable crashlytics
  bool get enableCrashlytics;

  /// Whether to enable analytics
  bool get enableAnalytics;

  /// AdMob Banner Ad Unit ID
  String get adBannerUnitId;

  /// AdMob Interstitial Ad Unit ID
  String get adInterstitialUnitId;

  /// AdMob Rewarded Ad Unit ID
  String get adRewardedUnitId;

  /// Ad load timeout duration
  Duration get adLoadTimeout;

  /// Whether to show debug banner
  bool get showDebugBanner;

  /// Whether to use test ads
  bool get useTestAds;

  /// Whether this is a production environment
  bool get isProduction => environment == Environment.prod;

  /// Whether this is a development environment
  bool get isDevelopment => environment == Environment.dev;

  /// Whether this is a staging environment
  bool get isStaging => environment == Environment.staging;
}

/// Singleton to hold the current environment configuration
class AppConfig {
  static EnvConfig? _config;

  AppConfig._();

  /// Initialize the app configuration with the given environment config
  static void init(EnvConfig config) {
    _config = config;
  }

  /// Get the current configuration
  /// Throws if not initialized
  static EnvConfig get instance {
    if (_config == null) {
      throw Exception(
        'AppConfig not initialized. Call AppConfig.init() first.',
      );
    }
    return _config!;
  }

  /// Check if the configuration has been initialized
  static bool get isInitialized => _config != null;
}
