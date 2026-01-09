# Copilot Instructions: Production Deployment Restructuring

## Project Overview
This is a Flutter quiz application that needs to be restructured for production deployment.

## Environment Configuration

### 1. Environment Variables
- Create separate configuration files for different environments:
  - `lib/config/env/dev_config.dart`
  - `lib/config/env/staging_config.dart`
  - `lib/config/env/prod_config.dart`
- Never hardcode API keys, secrets, or sensitive URLs
- Use `flutter_dotenv` or `--dart-define` for environment variables

### 2. Flavor/Build Configuration
- Set up Flutter flavors for dev, staging, and production
- Create separate `main_dev.dart`, `main_staging.dart`, `main_prod.dart` entry points
- Configure Android `build.gradle` and iOS schemes for each flavor

## Code Structure

### Recommended Folder Structure
```
lib/
├── config/
│   ├── env/
│   ├── routes/
│   └── themes/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   └── utils/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── blocs/ or providers/
│   ├── pages/
│   └── widgets/
└── main.dart
```

## Security Checklist

- [ ] Remove all debug prints and console logs
- [ ] Implement certificate pinning for API calls
- [ ] Obfuscate Dart code using `--obfuscate --split-debug-info`
- [ ] Secure local storage (use `flutter_secure_storage`)
- [ ] Implement proper authentication token handling
- [ ] Remove any test/mock data
- [ ] Validate all user inputs

## Performance Optimization

- [ ] Enable tree shaking
- [ ] Optimize images and assets
- [ ] Implement lazy loading for heavy screens
- [ ] Use `const` constructors where possible
- [ ] Profile and fix memory leaks
- [ ] Minimize app size by removing unused dependencies

## Build Commands

### Android Production Build
```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info
```

### iOS Production Build
```bash
flutter build ipa --release --obfuscate --split-debug-info=build/debug-info
```

## Pre-Deployment Checklist

- [ ] Update `pubspec.yaml` version number
- [ ] Update app icons and splash screens
- [ ] Configure proper app signing (Android keystore, iOS certificates)
- [ ] Set up crash reporting (Firebase Crashlytics, Sentry)
- [ ] Configure analytics
- [ ] Test on multiple devices and OS versions
- [ ] Review and update `AndroidManifest.xml` permissions
- [ ] Review and update `Info.plist` permissions and descriptions
- [ ] Remove unused permissions

## Dependencies Review

- Remove dev-only dependencies from production
- Ensure all dependencies are up-to-date and secure
- Check for deprecated packages

## When Helping with This Project

1. Always suggest environment-specific configurations
2. Recommend separating business logic from UI
3. Enforce proper error handling patterns
4. Suggest unit and widget tests for critical features
5. Follow clean architecture principles
6. Use proper state management (BLoC, Provider, or Riverpod)
7. Implement proper logging that can be disabled in production

