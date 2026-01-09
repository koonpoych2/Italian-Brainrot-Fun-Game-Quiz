import 'env_config.dart';

/// Production environment configuration
class ProdConfig extends EnvConfig {
  const ProdConfig._();

  static const ProdConfig _instance = ProdConfig._();
  factory ProdConfig() => _instance;

  @override
  Environment get environment => Environment.prod;

  @override
  String get appName => 'Brainrot Quiz';

  @override
  bool get enableLogging => false;

  @override
  bool get enableCrashlytics => true;

  @override
  bool get enableAnalytics => true;

  // AdMob Production Ad Unit IDs
  // TODO: Replace these with your actual production ad unit IDs from AdMob console
  @override
  String get adBannerUnitId => const String.fromEnvironment(
    'BANNER_AD_UNIT_ID',
    defaultValue: 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx',
  );

  @override
  String get adInterstitialUnitId => const String.fromEnvironment(
    'INTERSTITIAL_AD_UNIT_ID',
    defaultValue: 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx',
  );

  @override
  String get adRewardedUnitId => const String.fromEnvironment(
    'REWARDED_AD_UNIT_ID',
    defaultValue: 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx',
  );

  @override
  Duration get adLoadTimeout => const Duration(seconds: 30);

  @override
  bool get showDebugBanner => false;

  @override
  bool get useTestAds => false;
}
