import 'env_config.dart';

/// Staging environment configuration
class StagingConfig extends EnvConfig {
  const StagingConfig._();

  static const StagingConfig _instance = StagingConfig._();
  factory StagingConfig() => _instance;

  @override
  Environment get environment => Environment.staging;

  @override
  String get appName => 'Brainrot Quiz (Staging)';

  @override
  bool get enableLogging => true;

  @override
  bool get enableCrashlytics => true;

  @override
  bool get enableAnalytics => true;

  // AdMob Test Ad Unit IDs (use test ads in staging)
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
