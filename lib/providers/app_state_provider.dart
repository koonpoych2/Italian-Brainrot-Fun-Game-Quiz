import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class AppStateProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  // State variables
  int _highScore = 0;
  List<int> _unlockedSounds = [];
  List<int> _unlockedWiki = [];

  // Getters
  int get highScore => _highScore;
  List<int> get unlockedSounds => _unlockedSounds;
  List<int> get unlockedWiki => _unlockedWiki;

  /// Initialize state from storage
  Future<void> loadFromStorage() async {
    _highScore = _storage.getHighScore();
    _unlockedSounds = _storage.getUnlockedSounds();
    _unlockedWiki = _storage.getUnlockedWiki();
    notifyListeners();
  }

  // ============ HIGH SCORE METHODS ============
  Future<void> updateHighScore(int score) async {
    if (score > _highScore) {
      _highScore = score;
      await _storage.setHighScore(score);
      notifyListeners();
    }
  }

  // ============ SOUND UNLOCK METHODS ============
  bool isSoundUnlocked(int index) {
    return _unlockedSounds.contains(index);
  }

  Future<bool> unlockSound(int index) async {
    if (_unlockedSounds.contains(index)) {
      return true; // Already unlocked
    }

    // TODO: Your friend will add video ad here
    // For now, unlock directly (free)
    _unlockedSounds.add(index);
    await _storage.unlockSound(index);
    notifyListeners();
    return true;
  }

  // ============ WIKI UNLOCK METHODS ============
  bool isWikiUnlocked(int index) {
    return _unlockedWiki.contains(index);
  }

  Future<bool> unlockWiki(int index) async {
    if (_unlockedWiki.contains(index)) {
      return true; // Already unlocked
    }

    // TODO: Your friend will add video ad here
    // For now, unlock directly (free)
    _unlockedWiki.add(index);
    await _storage.unlockWiki(index);
    notifyListeners();
    return true;
  }

  /// Reward player after completing a quiz
  Future<void> onQuizComplete(int score, int maxScore) async {
    // Update high score
    await updateHighScore(score);

    // Auto-unlock items based on score thresholds
    if (score >= 5 && !isSoundUnlocked(3)) {
      _unlockedSounds.add(3);
      await _storage.unlockSound(3);
    }
    if (score >= 10 && !isWikiUnlocked(2)) {
      _unlockedWiki.add(2);
      await _storage.unlockWiki(2);
    }

    notifyListeners();
  }

  // ============ RESET (for testing) ============
  Future<void> resetAll() async {
    await _storage.resetAll();
    _highScore = 0;
    _unlockedSounds = [0, 1, 2];
    _unlockedWiki = [0, 1];
    notifyListeners();
  }
}
