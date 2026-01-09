# Build Commands for Brainrot Quiz

This document contains all the build commands for different environments and platforms.

---

## Development Builds

### Run Development (Default)
```bash
flutter run
```
or explicitly:
```bash
flutter run -t lib/main_dev.dart
```

### Run Staging
```bash
flutter run -t lib/main_staging.dart
```

### Run Production
```bash
flutter run -t lib/main_prod.dart
```

---

## Android Builds

### Development APK
```bash
flutter build apk -t lib/main_dev.dart --debug
```

### Staging APK
```bash
flutter build apk -t lib/main_staging.dart --release
```

### Production APK
```bash
flutter build apk -t lib/main_prod.dart --release --obfuscate --split-debug-info=build/debug-info
```

### Production App Bundle (for Play Store)
```bash
flutter build appbundle -t lib/main_prod.dart --release --obfuscate --split-debug-info=build/debug-info
```

---

## iOS Builds

### Development Build
```bash
flutter build ios -t lib/main_dev.dart --debug
```

### Staging Build
```bash
flutter build ios -t lib/main_staging.dart --release
```

### Production Build (for App Store)
```bash
flutter build ipa -t lib/main_prod.dart --release --obfuscate --split-debug-info=build/debug-info
```

---

## Environment Variables (Using --dart-define)

You can pass environment variables at build time:

### Example with AdMob Production IDs
```bash
flutter build apk -t lib/main_prod.dart --release \
  --dart-define=BANNER_AD_UNIT_ID=ca-app-pub-xxxxx/xxxxx \
  --dart-define=INTERSTITIAL_AD_UNIT_ID=ca-app-pub-xxxxx/xxxxx \
  --dart-define=REWARDED_AD_UNIT_ID=ca-app-pub-xxxxx/xxxxx \
  --obfuscate --split-debug-info=build/debug-info
```

---

## Windows Batch Scripts

### build_dev.bat
```batch
@echo off
echo Building Development APK...
flutter build apk -t lib/main_dev.dart --debug
echo Done!
pause
```

### build_staging.bat
```batch
@echo off
echo Building Staging APK...
flutter build apk -t lib/main_staging.dart --release
echo Done!
pause
```

### build_prod.bat
```batch
@echo off
echo Building Production App Bundle...
flutter build appbundle -t lib/main_prod.dart --release --obfuscate --split-debug-info=build/debug-info
echo Done!
pause
```

---

## Clean Build

Before building for production, it's recommended to clean the project:

```bash
flutter clean
flutter pub get
flutter build appbundle -t lib/main_prod.dart --release --obfuscate --split-debug-info=build/debug-info
```

---

## Analyze Code

Before any release, run the analyzer:

```bash
flutter analyze
```

---

## Run Tests

```bash
flutter test
```

---

## Pre-Release Checklist

1. [ ] Update version in `pubspec.yaml`
2. [ ] Run `flutter analyze` - no errors
3. [ ] Run `flutter test` - all tests pass
4. [ ] Replace test AdMob IDs with production IDs in `prod_config.dart`
5. [ ] Verify app signing configuration
6. [ ] Test on real devices
7. [ ] Clean build: `flutter clean && flutter pub get`
8. [ ] Build with obfuscation
9. [ ] Save debug symbols (`build/debug-info`) for crash reporting

---

## Output Locations

- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **App Bundle**: `build/app/outputs/bundle/release/app-release.aab`
- **IPA**: `build/ios/ipa/`
- **Debug Info**: `build/debug-info/`
