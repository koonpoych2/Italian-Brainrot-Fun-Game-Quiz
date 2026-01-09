/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Brainrot Quiz';
  static const String appVersion = '1.0.0';
  static const int appBuildNumber = 1;

  // Storage Keys
  static const String keyUserScore = 'user_score';
  static const String keyHighScore = 'high_score';
  static const String keyCompletedQuizzes = 'completed_quizzes';
  static const String keyUnlockedItems = 'unlocked_items';
  static const String keyUserPreferences = 'user_preferences';
  static const String keySoundEnabled = 'sound_enabled';
  static const String keyMusicEnabled = 'music_enabled';
  static const String keyVibrationEnabled = 'vibration_enabled';
  static const String keyDarkMode = 'dark_mode';
  static const String keyFirstLaunch = 'first_launch';
  static const String keyLastPlayedDate = 'last_played_date';
  static const String keyTotalCoins = 'total_coins';
  static const String keyWatchedAdsCount = 'watched_ads_count';

  // Quiz Settings
  static const int defaultQuestionCount = 10;
  static const int maxQuestionCount = 50;
  static const int minQuestionCount = 5;
  static const int defaultTimePerQuestion = 30; // seconds
  static const int maxTimePerQuestion = 60; // seconds
  static const int minTimePerQuestion = 10; // seconds

  // Rewards
  static const int coinsPerCorrectAnswer = 10;
  static const int coinsPerWatchedAd = 50;
  static const int coinsToUnlockItem = 100;
  static const int bonusCoinsForPerfectScore = 50;
  static const int bonusCoinsForStreak = 5;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
  static const Duration splashDuration = Duration(seconds: 2);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;
  static const double largeBorderRadius = 24.0;
  static const double cardElevation = 4.0;

  // Asset Paths
  static const String imagesPath = 'assets/images/';
  static const String iconsPath = 'assets/icons/';
  static const String soundsPath = 'assets/sounds/';
  static const String soundPath = 'assets/sound/';

  // Network
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Ad Settings
  static const int adsIntervalBetweenInterstitials =
      3; // Show after every N quizzes
  static const Duration minTimeBetweenAds = Duration(minutes: 2);

  // Limits
  static const int maxUsernameLength = 20;
  static const int minUsernameLength = 3;
  static const int maxLeaderboardEntries = 100;
}

/// Quiz difficulty levels
enum QuizDifficulty {
  easy('Easy', 1.0),
  medium('Medium', 1.5),
  hard('Hard', 2.0);

  final String displayName;
  final double multiplier;

  const QuizDifficulty(this.displayName, this.multiplier);
}

/// Quiz categories
enum QuizCategory {
  all('All', 'all'),
  memes('Memes', 'memes'),
  viral('Viral', 'viral'),
  trending('Trending', 'trending');

  final String displayName;
  final String id;

  const QuizCategory(this.displayName, this.id);
}

/// Sound effect types
enum SoundEffect {
  correct('correct.mp3'),
  wrong('wrong.mp3'),
  click('click.mp3'),
  complete('complete.mp3'),
  reward('reward.mp3'),
  countdown('countdown.mp3');

  final String fileName;

  const SoundEffect(this.fileName);

  String get path => '${AppConstants.soundsPath}$fileName';
}
