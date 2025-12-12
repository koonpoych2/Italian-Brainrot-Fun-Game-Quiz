# Quick Reference Guide - Persistent Storage & State Management

## 🚀 Quick Start

### Check Current State
```dart
final appState = context.watch<AppStateProvider>();
print('Coins: ${appState.coins}');
print('High Score: ${appState.highScore}');
```

### Update State
```dart
final appState = context.read<AppStateProvider>();
await appState.addCoins(50);
await appState.unlockSound(5, cost: 100);
```

---

## 📋 Common Tasks

### Task 1: Display Coins in UI
```dart
Consumer<AppStateProvider>(
  builder: (context, appState, child) {
    return Text('🪙 ${appState.coins}');
  },
)
```

### Task 2: Check if Item is Unlocked
```dart
final appState = context.read<AppStateProvider>();
bool isUnlocked = appState.isSoundUnlocked(5);

if (isUnlocked) {
  // Show unlocked content
} else {
  // Show lock icon
}
```

### Task 3: Purchase Item with Coins
```dart
final appState = context.read<AppStateProvider>();
bool success = await appState.unlockSound(5, cost: 100);

if (success) {
  // Item unlocked!
} else {
  // Not enough coins
}
```

### Task 4: Save Quiz Score
```dart
final appState = context.read<AppStateProvider>();
await appState.onQuizComplete(score, maxScore);
// Automatically saves high score and awards coins
```

---

## 🎯 Provider Usage

### When to use `watch` vs `read`

#### Use `context.watch<AppStateProvider>()` when:
- ✅ Widget needs to rebuild on state changes
- ✅ Displaying state in UI
- ✅ Inside build() method

```dart
@override
Widget build(BuildContext context) {
  final appState = context.watch<AppStateProvider>();
  return Text('Coins: ${appState.coins}');
}
```

#### Use `context.read<AppStateProvider>()` when:
- ✅ Performing actions/updates
- ✅ Inside event handlers (onPressed, onTap)
- ✅ Don't need to listen to changes

```dart
onPressed: () {
  final appState = context.read<AppStateProvider>();
  appState.addCoins(50);
}
```

---

## 💾 Storage Operations

### Direct Storage Access (if needed)
```dart
final storage = StorageService();

// Read
int coins = storage.getCoins();
int highScore = storage.getHighScore();
List<int> unlockedSounds = storage.getUnlockedSounds();

// Write
await storage.setCoins(100);
await storage.setHighScore(15);
await storage.unlockSound(5);

// Reset (testing)
await storage.resetAll();
```

---

## 🎮 Economy System

### Earn Coins
```dart
// Method 1: Manual
await appState.addCoins(50);

// Method 2: After Quiz (automatic)
await appState.onQuizComplete(score, maxScore);
// Gives: score × 10 + (50 if perfect score)
```

### Spend Coins
```dart
// Returns true if successful, false if not enough coins
bool success = await appState.spendCoins(100);
```

---

## 🔓 Unlock System

### Sounds
```dart
// Check status
bool isUnlocked = appState.isSoundUnlocked(5);

// Unlock with coins (default cost: 100)
bool success = await appState.unlockSound(5);

// Unlock with custom cost
bool success = await appState.unlockSound(5, cost: 150);
```

### Wiki Items
```dart
// Check status
bool isUnlocked = appState.isWikiUnlocked(3);

// Unlock with coins (default cost: 50)
bool success = await appState.unlockWiki(3);

// Unlock with custom cost
bool success = await appState.unlockWiki(3, cost: 75);
```

---

## 🎨 UI Patterns

### Show Unlock Dialog
```dart
void showUnlockDialog(BuildContext context, int index, int cost) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Unlock Item'),
      content: Text('Spend $cost coins?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final success = await context.read<AppStateProvider>()
                .unlockSound(index, cost: cost);
            Navigator.pop(ctx);
            
            if (!success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Not enough coins!')),
              );
            }
          },
          child: Text('Unlock'),
        ),
      ],
    ),
  );
}
```

### Show Coins Badge
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.black, width: 2),
  ),
  child: Row(
    children: [
      Text('🪙', style: TextStyle(fontSize: 18)),
      SizedBox(width: 4),
      Text('${appState.coins}'),
    ],
  ),
)
```

### Lock Overlay
```dart
Stack(
  children: [
    // Your content
    Image.asset('assets/image.png'),
    
    // Lock overlay (if locked)
    if (!isUnlocked)
      Container(
        color: Colors.black.withOpacity(0.8),
        child: Center(
          child: Icon(Icons.lock, color: Colors.white, size: 50),
        ),
      ),
  ],
)
```

---

## 🐛 Debugging

### Print Current State
```dart
void debugState(AppStateProvider appState) {
  print('=== APP STATE ===');
  print('High Score: ${appState.highScore}');
  print('Coins: ${appState.coins}');
  print('Unlocked Sounds: ${appState.unlockedSounds}');
  print('Unlocked Wiki: ${appState.unlockedWiki}');
  print('================');
}
```

### Reset All Data
```dart
// Add this button in debug mode
ElevatedButton(
  onPressed: () async {
    final appState = context.read<AppStateProvider>();
    await appState.resetAll();
    print('All data reset!');
  },
  child: Text('🔄 Reset All Data'),
)
```

### Check SharedPreferences Directly
```dart
import 'package:shared_preferences/shared_preferences.dart';

Future<void> debugSharedPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  print('All Keys: ${prefs.getKeys()}');
  print('High Score: ${prefs.getInt('high_score')}');
  print('Coins: ${prefs.getInt('total_coins')}');
}
```

---

## ⚡ Performance Tips

1. **Use `const` constructors** where possible
2. **Use `Consumer` for partial rebuilds**
   ```dart
   Consumer<AppStateProvider>(
     builder: (context, appState, child) {
       return Text('${appState.coins}');
     },
   )
   ```
3. **Use `Selector` for specific properties**
   ```dart
   Selector<AppStateProvider, int>(
     selector: (_, state) => state.coins,
     builder: (_, coins, __) {
       return Text('$coins');
     },
   )
   ```

---

## 📦 Constants

| Item | Default Cost |
|------|-------------|
| Sound Unlock | 100 🪙 |
| Wiki Unlock | 50 🪙 |
| Per Correct Answer | +10 🪙 |
| Perfect Score Bonus | +50 🪙 |

| Threshold | Reward |
|-----------|--------|
| Score ≥ 5 | Auto-unlock Sound #3 |
| Score ≥ 10 | Auto-unlock Wiki #2 |

---

## 🔗 Related Files

- `lib/services/storage_service.dart` - Storage layer
- `lib/providers/app_state_provider.dart` - State management
- `lib/main.dart` - Provider setup
- `PERSISTENCE_GUIDE.md` - Full documentation
- `IMPLEMENTATION_SUMMARY.md` - What was implemented

---

## ✅ Checklist for Adding New Feature

- [ ] Add storage method in `StorageService`
- [ ] Add state variable in `AppStateProvider`
- [ ] Add getter/setter methods
- [ ] Load data in `loadFromStorage()`
- [ ] Call `notifyListeners()` after changes
- [ ] Use `context.watch()` in UI
- [ ] Use `context.read()` for actions
- [ ] Test persistence (restart app)

---

**Quick Tip:** When in doubt, use `context.watch()` in build methods and `context.read()` in event handlers! 🚀