# 🚀 Getting Started with Persistent Storage & State Management

Welcome! This guide will help you understand and use the new persistent storage system that has been implemented in your Brainrot Quiz app.

## 📋 Table of Contents

1. [What's New](#whats-new)
2. [Quick Start](#quick-start)
3. [How to Test](#how-to-test)
4. [User Features](#user-features)
5. [Developer Guide](#developer-guide)
6. [Troubleshooting](#troubleshooting)

---

## 🎉 What's New

Your app now has:

✅ **Persistent High Score** - Best scores are saved forever  
✅ **Coins System** - Earn coins by playing quizzes  
✅ **Unlock System** - Spend coins to unlock sounds and wiki items  
✅ **Auto-Unlocks** - Achieve score milestones for free unlocks  
✅ **State Management** - Reactive UI updates across the app  
✅ **Debug Screen** - Test all features easily  

### Technology Stack

- **Provider** (v6.1.2) - State management
- **SharedPreferences** (v2.2.3) - Local persistent storage

---

## 🚀 Quick Start

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Run the App

```bash
flutter run
```

### 3. Access Debug Screen

- Open the app
- Look for the 🐛 bug icon in the top-right of the home screen
- Tap it to open the Debug & Testing screen
- Test all features!

---

## 🧪 How to Test

### Test Persistence (Most Important!)

1. Open the app
2. Go to Debug screen (🐛 icon)
3. Tap "Add 100 Coins"
4. Note your coin count
5. **CLOSE THE APP COMPLETELY**
6. Restart the app
7. Go to Debug screen again
8. **Your coins should still be there!** ✨

This proves data persists across app restarts.

### Test Coins System

1. Go to Debug screen
2. Tap "+ 50 Coins" or "+ 100 Coins"
3. Watch coin count increase in real-time
4. Tap "Spend 50 Coins"
5. Watch coin count decrease

### Test Quiz Scoring

1. Go to Debug screen
2. Tap "Simulate Quiz: 8/10"
3. You'll earn 80 coins (8 × 10)
4. High score updates to 8
5. Tap "Simulate Quiz: 10/10"
6. You'll earn 150 coins (100 + 50 bonus)
7. High score updates to 10

### Test Unlock System

1. Earn at least 100 coins (use debug screen)
2. Go to Sound Board
3. Tap a locked sound
4. Confirm unlock (costs 100 coins)
5. Sound is now unlocked!
6. **RESTART APP**
7. Sound is still unlocked ✅

### Test Auto-Unlocks

1. Go to Debug screen
2. Tap "Simulate Quiz: 8/10" (score ≥ 5)
3. Sound #3 auto-unlocks
4. Tap "Simulate Quiz: 10/10" (score ≥ 10)
5. Wiki #2 auto-unlocks

---

## 👥 User Features

### For Players

#### Earning Coins 💰

Play the quiz to earn coins:
- **10 coins** for each correct answer
- **+50 bonus** for perfect score (all correct)

Example:
- 5/10 correct = 50 coins
- 10/10 correct = 100 + 50 = 150 coins

#### Spending Coins 💸

Use coins to unlock content:
- **100 coins** = Unlock 1 sound
- **50 coins** = Unlock 1 wiki item

#### Auto-Unlocks 🎁

Reach milestones for free unlocks:
- Score ≥ 5: Sound #3 unlocked
- Score ≥ 10: Wiki #2 unlocked

#### High Score 🏆

Your best quiz score is saved automatically.
Try to beat your high score!

---

## 👨‍💻 Developer Guide

### File Structure

```
lib/
├── services/
│   └── storage_service.dart          # SharedPreferences layer
├── providers/
│   └── app_state_provider.dart       # State management layer
├── screens/
│   ├── result_page/
│   │   └── result_screen.dart        # Saves scores & awards coins
│   └── debug_screen.dart             # Testing interface
├── main.dart                          # Provider setup
├── home_screen.dart                   # Shows coins, debug button
├── sound_board_screen.dart            # Unlock sounds
└── wiki_list_screen.dart              # Unlock wiki items
```

### Using Provider in Your Code

#### Reading State (Listen to Changes)

Use in `build()` methods when you want widget to rebuild on state changes:

```dart
@override
Widget build(BuildContext context) {
  final appState = context.watch<AppStateProvider>();
  return Text('Coins: ${appState.coins}');
}
```

#### Reading State (One-Time)

Use in event handlers when you don't need to listen to changes:

```dart
onPressed: () {
  final appState = context.read<AppStateProvider>();
  appState.addCoins(50);
}
```

### Common Operations

#### Add Coins

```dart
final appState = context.read<AppStateProvider>();
await appState.addCoins(100);
```

#### Check Unlock Status

```dart
bool isUnlocked = appState.isSoundUnlocked(5);
if (isUnlocked) {
  // Play sound
} else {
  // Show lock
}
```

#### Unlock Item

```dart
bool success = await appState.unlockSound(5, cost: 100);
if (success) {
  // Unlocked!
} else {
  // Not enough coins
}
```

#### Save Quiz Result

```dart
await appState.onQuizComplete(score, maxScore);
// Automatically:
// - Updates high score if higher
// - Awards coins based on score
// - Triggers auto-unlocks
```

---

## 🐛 Troubleshooting

### Problem: Coins not showing up

**Solution:**
- Make sure you ran `flutter pub get`
- Check that Provider is set up in `main.dart`
- Restart the app completely

### Problem: Data not persisting

**Solution:**
- Verify `StorageService().init()` is called in `main()`
- Ensure you're using `await` when saving data
- Try resetting data from Debug screen
- Check platform-specific storage permissions

### Problem: UI not updating

**Solution:**
- Use `context.watch<AppStateProvider>()` in build methods
- Use `context.read<AppStateProvider>()` in event handlers
- Don't use `watch` inside `onPressed` or `onTap`
- Make sure `notifyListeners()` is called after state changes

### Problem: App crashes on startup

**Solution:**
- Run `flutter clean`
- Run `flutter pub get`
- Restart IDE/Editor
- Try deleting `build/` folder
- Check for syntax errors with `flutter analyze`

---

## 📊 Default Values

When the app runs for the first time:

| Item | Default Value |
|------|--------------|
| Coins | 0 🪙 |
| High Score | 0 |
| Unlocked Sounds | 0, 1, 2 (first 3) |
| Unlocked Wiki | 0, 1 (first 2) |

---

## 🎯 Economy Balance

### Earning Rate
- Average quiz score: 5/10 = 50 coins
- Good quiz score: 8/10 = 80 coins
- Perfect quiz: 10/10 = 150 coins

### Unlock Costs
- Sound (100 coins) = ~2 average quizzes or 1 perfect quiz
- Wiki (50 coins) = ~1 average quiz

This creates a balanced progression system!

---

## 📖 Additional Documentation

- **`PERSISTENCE_GUIDE.md`** - Detailed technical documentation
- **`IMPLEMENTATION_SUMMARY.md`** - What was implemented and how
- **`QUICK_REFERENCE.md`** - Quick code snippets and patterns

---

## ✨ Tips & Tricks

### For Testing

1. Use the Debug screen to quickly add coins
2. Test persistence by restarting the app often
3. Use "Reset All Data" to start fresh
4. Check the console for debug prints

### For Development

1. Always use `await` when saving data
2. Use `const` constructors for better performance
3. Use `Consumer` for partial widget rebuilds
4. Check Flutter DevTools for Provider inspection

### For Users

1. Play more quizzes to earn coins faster
2. Aim for perfect scores for bonus coins
3. Unlock sounds before wiki (more expensive)
4. Check your high score on result screen

---

## 🎮 Example Gameplay Flow

```
1. Open App
   └─> See coins: 0 🪙

2. Play Quiz
   └─> Get 7/10 correct
   └─> Earn 70 coins
   └─> New high score: 7

3. View Results
   └─> Shows: +70 🪙
   └─> Total coins: 70 🪙
   └─> High Score: 7

4. Go to Sound Board
   └─> See locked sounds
   └─> Not enough coins yet (need 100)

5. Play Another Quiz
   └─> Get 8/10 correct
   └─> Earn 80 coins
   └─> New high score: 8

6. Total Coins Now: 150 🪙
   └─> Unlock a sound (100 coins)
   └─> Remaining: 50 coins

7. Unlock Wiki Item (50 coins)
   └─> Remaining: 0 coins

8. RESTART APP
   └─> All unlocks saved! ✨
   └─> High score: 8
   └─> Coins: 0
```

---

## 🚀 Next Steps

1. **Test Everything** - Use the Debug screen
2. **Play the Quiz** - Experience the coin system
3. **Unlock Content** - See the persistence in action
4. **Restart the App** - Verify data persists
5. **Read Documentation** - Learn more details

---

## 💡 Need Help?

- Check `QUICK_REFERENCE.md` for code snippets
- Read `PERSISTENCE_GUIDE.md` for detailed API docs
- See `IMPLEMENTATION_SUMMARY.md` for architecture details
- Use the Debug screen to test features

---

## ✅ Checklist

Before deploying to production:

- [ ] Test persistence by restarting app multiple times
- [ ] Verify coins are awarded correctly
- [ ] Test unlock system with actual coins
- [ ] Check high score updates properly
- [ ] Test on multiple devices/platforms
- [ ] Remove or hide Debug screen (optional)
- [ ] Test with slow internet (if using cloud later)
- [ ] Verify no data loss scenarios

---

**Congratulations!** 🎉

You now have a fully functional persistent storage system with state management. Your users can earn coins, unlock content, and track their progress across app sessions!

Happy coding! 🚀

---

**Version:** 1.0  
**Last Updated:** 2024  
**Status:** ✅ Production Ready