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
  // ⚠️ Replace these with your REAL ad unit IDs from AdMob Console:
  // https://apps.admob.com → Apps → Your App → Ad units
  @override
  String get adBannerUnitId => const String.fromEnvironment(
    'BANNER_AD_UNIT_ID',
    defaultValue: 'ca-app-pub-4822776885970693/9601498089', // TODO: replace XXXXXXXXXX
  );

  @override
  String get adInterstitialUnitId => const String.fromEnvironment(
    'INTERSTITIAL_AD_UNIT_ID',
    defaultValue: 'ca-app-pub-4822776885970693/3597334696', // TODO: replace XXXXXXXXXX
  );

  @override
  String get adRewardedUnitId => const String.fromEnvironment(
    'REWARDED_AD_UNIT_ID',
    defaultValue: 'ca-app-pub-4822776885970693/1862608860', // TODO: replace XXXXXXXXXX
  );

  @override
  Duration get adLoadTimeout => const Duration(seconds: 30);

  @override
  bool get showDebugBanner => false;

  @override
  bool get useTestAds => false;
}
