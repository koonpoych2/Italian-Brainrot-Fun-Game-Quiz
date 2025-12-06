# Persistent Storage & State Management Guide

This guide explains how the persistent data storage and state management works in the Brainrot Quiz app.

## 🎯 Overview

The app now uses:
- **`provider`** - For reactive state management across the app
- **`shared_preferences`** - For persistent local storage (data survives app restarts)

## 📦 What Data is Persisted?

1. **High Score** - Your best quiz score
2. **Coins** - Total coins earned
3. **Unlocked Sounds** - Which soundboard items you've unlocked
4. **Unlocked Wiki Items** - Which wiki entries you've unlocked

## 🏗️ Architecture

### Files Structure

```
lib/
├── services/
│   └── storage_service.dart        # Handles SharedPreferences operations
├── providers/
│   └── app_state_provider.dart     # State management with Provider
└── screens/
    └── result_page/
        └── result_screen.dart       # Saves quiz results
```

### How It Works

```
┌─────────────────┐
│  User plays     │
│  quiz           │
└────────┬────────┘
         │
         v
┌─────────────────┐
│  Score saved    │
│  via Provider   │
└────────┬────────┘
         │
         v
┌─────────────────┐
│  Data persisted │
│  via SharedPrefs│
└─────────────────┘
```

## 💰 Coins System

### Earning Coins
- **10 coins** per correct answer
- **+50 bonus** for perfect score (all answers correct)

### Spending Coins
- **100 coins** to unlock a sound
- **50 coins** to unlock a wiki item

### Auto-Unlocks
- Score ≥ 5: Automatically unlock Sound #3
- Score ≥ 10: Automatically unlock Wiki Item #2

## 🔓 Unlock System

### Default Unlocked Items
- **Sounds**: Indices 0, 1, 2 (first 3 sounds)
- **Wiki**: Indices 0, 1 (first 2 wiki items)

### Unlocking Process
1. Tap on a locked item
2. Dialog shows the cost
3. If you have enough coins, confirm to unlock
4. The unlock is saved permanently

## 📝 Using the State Provider

### Reading State
```dart
// In any widget, use context.watch to listen to changes
final appState = context.watch<AppStateProvider>();
print('Coins: ${appState.coins}');
print('High Score: ${appState.highScore}');
```

### Checking Unlock Status
```dart
final appState = context.read<AppStateProvider>();
bool isUnlocked = appState.isSoundUnlocked(5);
bool isWikiUnlocked = appState.isWikiUnlocked(3);
```

### Updating State
```dart
final appState = context.read<AppStateProvider>();

// Add coins
await appState.addCoins(100);

// Unlock sound (costs coins)
bool success = await appState.unlockSound(5, cost: 100);

// Unlock wiki (costs coins)
bool success = await appState.unlockWiki(3, cost: 50);
```

## 🔧 Storage Service API

The `StorageService` is a singleton that manages SharedPreferences:

```dart
final storage = StorageService();

// High Score
int score = storage.getHighScore();
await storage.setHighScore(15);

// Coins
int coins = storage.getCoins();
await storage.addCoins(50);

// Unlocked Sounds
List<int> sounds = storage.getUnlockedSounds();
await storage.unlockSound(5);

// Unlocked Wiki
List<int> wiki = storage.getUnlockedWiki();
await storage.unlockWiki(3);

// Reset everything (for testing)
await storage.resetAll();
```

## 🧪 Testing

### To Reset All Data
Add a debug button in your UI:
```dart
ElevatedButton(
  onPressed: () async {
    final appState = context.read<AppStateProvider>();
    await appState.resetAll();
  },
  child: Text('Reset All Data'),
)
```

### To Check Current State
```dart
final appState = context.watch<AppStateProvider>();
print('High Score: ${appState.highScore}');
print('Coins: ${appState.coins}');
print('Unlocked Sounds: ${appState.unlockedSounds}');
print('Unlocked Wiki: ${appState.unlockedWiki}');
```

## 🚀 How to Extend

### Add New Persistent Data

1. **Add key in StorageService:**
```dart
static const String _newDataKey = 'new_data';
```

2. **Add getter/setter methods:**
```dart
String getNewData() {
  return _prefs.getString(_newDataKey) ?? '';
}

Future<void> setNewData(String value) async {
  await _prefs.setString(_newDataKey, value);
}
```

3. **Add to AppStateProvider:**
```dart
String _newData = '';
String get newData => _newData;

Future<void> loadFromStorage() async {
  // ... existing code
  _newData = _storage.getNewData();
  notifyListeners();
}
```

### Add New Features

Want to add achievements, levels, or other features? Follow this pattern:
1. Define storage methods in `StorageService`
2. Add state variables and methods in `AppStateProvider`
3. Use `context.watch<AppStateProvider>()` in UI to listen to changes
4. Use `context.read<AppStateProvider>()` to trigger actions

## 📱 Platform Support

SharedPreferences works on:
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🐛 Troubleshooting

### Data Not Saving?
- Check that `StorageService().init()` is called in `main()` before `runApp()`
- Ensure you're using `await` when saving data
- Verify `notifyListeners()` is called after state changes

### UI Not Updating?
- Use `context.watch<AppStateProvider>()` for widgets that need updates
- Use `context.read<AppStateProvider>()` for one-time reads or actions
- Never use `watch` inside event handlers (use `read` instead)

### Testing Issues?
- Use `await appState.resetAll()` to clear all data
- Restart the app to see persistent data in action
- Check Flutter DevTools for Provider state inspection

## 📚 Learn More

- [Provider Documentation](https://pub.dev/packages/provider)
- [SharedPreferences Documentation](https://pub.dev/packages/shared_preferences)
- [Flutter State Management](https://docs.flutter.dev/development/data-and-backend/state-mgmt/intro)

---

**Created for Brainrot Quiz App** 🧠🎮