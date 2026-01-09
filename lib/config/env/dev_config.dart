import 'env_config.dart';

/// Development environment configuration
class DevConfig extends EnvConfig {
  const DevConfig._();

  static const DevConfig _instance = DevConfig._();
  factory DevConfig() => _instance;

  @override
  Environment get environment => Environment.dev;

  @override
  String get appName => 'Brainrot Quiz (Dev)';

  @override
  bool get enableLogging => true;

  @override
  bool get enableCrashlytics => false;

  @override
  bool get enableAnalytics => false;

  // AdMob Test Ad Unit IDs (safe for development)
  @override
  String get adBannerUnitId => 'ca-app-pub-3940256099942544/6300978111';

  @override
  String get adInterstitialUnitId => 'ca-app-pub-3940256099942544/1033173712';

  @override
  String get adRewardedUnitId => 'ca-app-pub-3940256099942544/5224354917';

  @override
  Duration get adLoadTimeout => const Duration(seconds: 30);

  @override
  bool get showDebugBanner => true;

  @override
  bool get useTestAds => true;
}
