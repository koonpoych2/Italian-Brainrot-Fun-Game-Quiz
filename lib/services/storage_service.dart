import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _highScoreKey = 'high_score';
  static const String _unlockedSoundsKey = 'unlocked_sounds';
  static const String _unlockedWikiKey = 'unlocked_wiki';
  static const String _totalCoinsKey = 'total_coins';

  late SharedPreferences _prefs;

  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  /// Initialize SharedPreferences - call this in main()
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============ HIGH SCORE ============
  int getHighScore() {
    return _prefs.getInt(_highScoreKey) ?? 0;
  }

  Future<void> setHighScore(int score) async {
    final currentHighScore = getHighScore();
    if (score > currentHighScore) {
      await _prefs.setInt(_highScoreKey, score);
    }
  }

  // ============ UNLOCKED SOUNDS ============
  List<int> getUnlockedSounds() {
    final data = _prefs.getStringList(_unlockedSoundsKey);
    if (data == null) {
      // Default: first 3 sounds are unlocked
      return [0, 1, 2];
    }
    return data.map((e) => int.parse(e)).toList();
  }

  Future<void> unlockSound(int index) async {
    final unlocked = getUnlockedSounds();
    if (!unlocked.contains(index)) {
      unlocked.add(index);
      await _prefs.setStringList(
        _unlockedSoundsKey,
        unlocked.map((e) => e.toString()).toList(),
      );
    }
  }

  // ============ UNLOCKED WIKI ============
  List<int> getUnlockedWiki() {
    final data = _prefs.getStringList(_unlockedWikiKey);
    if (data == null) {
      // Default: first 2 wiki items are unlocked
      return [0, 1];
    }
    return data.map((e) => int.parse(e)).toList();
  }

  Future<void> unlockWiki(int index) async {
    final unlocked = getUnlockedWiki();
    if (!unlocked.contains(index)) {
      unlocked.add(index);
      await _prefs.setStringList(
        _unlockedWikiKey,
        unlocked.map((e) => e.toString()).toList(),
      );
    }
  }

  // ============ COINS ============
  int getCoins() {
    return _prefs.getInt(_totalCoinsKey) ?? 0;
  }

  Future<void> setCoins(int coins) async {
    await _prefs.setInt(_totalCoinsKey, coins);
  }

  Future<void> addCoins(int amount) async {
    final current = getCoins();
    await _prefs.setInt(_totalCoinsKey, current + amount);
  }

  // ============ RESET ALL DATA (for testing) ============
  Future<void> resetAll() async {
    await _prefs.clear();
  }
}
