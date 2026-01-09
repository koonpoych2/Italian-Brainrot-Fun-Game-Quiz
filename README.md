# 🧠 Brainrot Quiz App

A fun and engaging Flutter quiz application with persistent storage, coins economy, and unlockable content!

> **Production Ready** - This project follows clean architecture principles with environment-specific configurations for dev, staging, and production builds.

## ✨ Features

### 🎮 Quiz System
- Interactive quiz gameplay with multiple question types
- Image, sound, and text-based questions
- Real-time timer and scoring
- High score tracking

### 🎥 Video Ads Unlock System
- Watch video ads to unlock content
- No coins required - completely free
- Video ad integration ready for your friend
- Unlocks persist across app restarts

### 🔓 Unlock System
- Unlock sounds by watching video ads
- Unlock wiki items by watching video ads
- Auto-unlock rewards for score milestones
- All unlocks saved permanently

### 🎵 Sound Board
- 20 unique sounds
- First 3 unlocked by default
- Unlock more by watching video ads
- Interactive sound playback

### 📚 Wiki
- Character information and lore
- Unlockable entries
- Image galleries
- Detailed descriptions

### 💾 Persistent Storage
- All progress saved automatically
- High scores preserved
- Unlocked content remembered
- Works across app restarts

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.8.0 or higher)
- Dart SDK
- Android Studio / VS Code / Xcode

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd brainrot_quiz
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📱 How to Use

### Playing the Quiz

1. Tap "QUIZ" on the home screen
2. Answer questions by selecting options
3. Tap "OK" to submit your answer
4. Continue until you answer incorrectly or complete all questions
5. View your results and earned coins

### Unlocking Content

1. Navigate to Sound Board or Wiki
2. Tap on a locked item
3. Watch a video ad (your friend will add this)
4. Enjoy your unlocked content!

### Auto-Unlocks

- **Score ≥ 5:** Auto-unlock Sound #3
- **Score ≥ 10:** Auto-unlock Wiki #2

### Testing Features

1. Tap the 🐛 bug icon on home screen
2. Access the Debug & Testing screen
3. Test coins, scores, and unlocks
4. Use "Reset All Data" to start fresh

## 🏗️ Architecture

### State Management
- **Provider** for reactive state updates
- **ChangeNotifier** pattern for observable state
- Clean separation of concerns

### Data Persistence
- **SharedPreferences** for local storage
- **Singleton** pattern for storage service
- Automatic save/load on app lifecycle

### Project Structure

```
lib/
├── config/                    # Configuration files
│   ├── env/                   # Environment configurations
│   │   ├── env_config.dart    # Base config interface
│   │   ├── dev_config.dart    # Development settings
│   │   ├── staging_config.dart # Staging settings
│   │   └── prod_config.dart   # Production settings
│   ├── routes/                # App routing
│   │   └── app_routes.dart
│   └── themes/                # Theme configuration
│       └── app_theme.dart
├── core/                      # Core utilities
│   ├── constants/             # App-wide constants
│   │   └── app_constants.dart
│   ├── errors/                # Error handling
│   │   └── app_exceptions.dart
│   ├── network/               # Network utilities
│   └── utils/                 # Utility classes
│       └── app_logger.dart
├── data/                      # Data layer
│   ├── datasources/           # Data sources
│   ├── models/                # Data models
│   └── repositories/          # Repository implementations
├── domain/                    # Domain layer
│   ├── entities/              # Business entities
│   ├── repositories/          # Repository interfaces
│   └── usecases/              # Use cases
├── presentation/              # Presentation layer
│   ├── providers/             # State management
│   ├── pages/                 # Screen pages
│   └── widgets/               # Reusable widgets
├── components/                # Legacy UI components
├── models/                    # Legacy data models
├── providers/                 # Legacy providers
├── screens/                   # Legacy screens
├── services/                  # Business logic services
├── widgets/                   # Legacy widgets
├── main.dart                  # Default entry point (dev)
├── main_dev.dart              # Development entry point
├── main_staging.dart          # Staging entry point
└── main_prod.dart             # Production entry point
```

## 🔧 Environment Configuration

The app supports three environments:

| Environment | Entry Point | Debug Banner | Logging | Test Ads |
|-------------|-------------|--------------|---------|----------|
| Development | `main_dev.dart` | ✅ Yes | ✅ Yes | ✅ Yes |
| Staging | `main_staging.dart` | ✅ Yes | ✅ Yes | ✅ Yes |
| Production | `main_prod.dart` | ❌ No | ❌ No | ❌ No |

### Running Different Environments

```bash
# Development (default)
flutter run

# Staging
flutter run -t lib/main_staging.dart

# Production
flutter run -t lib/main_prod.dart
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  audioplayers: ^6.5.1
  flutter_svg: ^2.2.2
  google_fonts: ^6.3.2
  google_mobile_ads: ^5.2.0
  provider: ^6.1.2
  shared_preferences: ^2.2.3
```

## 🏗️ Build Commands

### Development Build
```bash
flutter build apk -t lib/main_dev.dart --debug
```

### Staging Build
```bash
flutter build apk -t lib/main_staging.dart --release
```

### Production Build (Obfuscated)
```bash
flutter build appbundle -t lib/main_prod.dart --release --obfuscate --split-debug-info=build/debug-info
```

### Using Build Scripts (Windows)
```bash
# From project root
scripts\build_dev.bat      # Development APK
scripts\build_staging.bat  # Staging APK
scripts\build_prod.bat     # Production App Bundle
```

## 🎯 Key Features Implementation

### Persistent Storage
```dart
// Storage Service handles SharedPreferences
StorageService().getCoins();
StorageService().setHighScore(10);
```

### State Management
```dart
// Provider pattern for reactive UI
final appState = context.watch<AppStateProvider>();
Text('Coins: ${appState.coins}');
```

### Unlock System
```dart
// Unlock content (free for now, video ads coming)
await appState.unlockSound(5);
await appState.unlockWiki(3);
```

## 📚 Documentation

- **[GETTING_STARTED.md](GETTING_STARTED.md)** - Complete setup and usage guide
- **[PERSISTENCE_GUIDE.md](PERSISTENCE_GUIDE.md)** - Detailed technical documentation
- **[VIDEO_ADS_INTEGRATION_GUIDE.md](VIDEO_ADS_INTEGRATION_GUIDE.md)** - Guide for adding video ads
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Code snippets and patterns
- **[DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)** - Pre-deployment checklist
- **[scripts/build_commands.md](scripts/build_commands.md)** - Complete build commands reference

## 🧪 Testing

### Manual Testing
1. Use the Debug screen (🐛 icon)
2. Test all features systematically
3. Verify persistence by restarting app
4. Check high scores and unlocks

### Automated Testing
```bash
flutter test
```

## 🔧 Development

### Adding New Features

1. **Storage**: Add methods to `StorageService`
2. **State**: Add variables/methods to `AppStateProvider`
3. **UI**: Use `context.watch()` to display state
4. **Actions**: Use `context.read()` to update state

### Code Style
- Follow Flutter best practices
- Use `const` constructors where possible
- Keep widgets small and focused
- Document complex logic

## 🐛 Troubleshooting

### Common Issues

**Data not persisting?**
- Verify `StorageService().init()` is called in `main()`
- Check you're using `await` for async operations
- Try resetting data from Debug screen

**UI not updating?**
- Use `context.watch()` in build methods
- Use `context.read()` in event handlers
- Ensure `notifyListeners()` is called

**Video ads integration?**
- See `VIDEO_ADS_INTEGRATION_GUIDE.md`
- Your friend will handle this part

**App crashes?**
- Run `flutter clean`
- Run `flutter pub get`
- Check for syntax errors with `flutter analyze`

## ✅ Production Checklist

Before releasing to production:

- [ ] Replace test AdMob IDs in `lib/config/env/prod_config.dart`
- [ ] Update version in `pubspec.yaml`
- [ ] Run `flutter analyze` - no errors
- [ ] Run `flutter test` - all tests pass
- [ ] Configure Android keystore signing
- [ ] Configure iOS certificates and provisioning profiles
- [ ] Test on real devices
- [ ] Save `build/debug-info/` for crash reporting

## 🌟 Future Enhancements

- [ ] Video ads integration (ready for your friend!)
- [ ] Cloud sync (Firebase)
- [ ] Achievements system
- [ ] Daily rewards
- [ ] Leaderboards
- [ ] More quiz categories
- [ ] Multiplayer mode
- [ ] Theme customization

## 📄 License

This project is private and not intended for public distribution.

## 👥 Contributors

Developed with AI assistance for educational purposes.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Provider package for state management
- SharedPreferences for local storage
- Google Fonts for typography
- Audioplayers for sound functionality

## 📞 Support

For issues or questions:
1. Check the documentation files
2. Use the Debug screen to test features
3. Review code comments for implementation details

---

**Version:** 1.0.0  
**Status:** ✅ Production Ready  
**Last Updated:** 2024

Made with ❤️ and Flutter