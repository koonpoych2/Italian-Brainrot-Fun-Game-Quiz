# 🎥 Video Ads Integration Guide

This guide is for your friend who will integrate video ads for unlocking sounds and wiki items.

## 📋 Overview

The app is **ready for video ads integration**. All unlock logic is in place, and your friend just needs to:
1. Add a video ads package
2. Show video ads before unlocking
3. Unlock content after ad is watched

---

## 🎯 Where to Add Video Ads

### Two Places Need Video Ads:

1. **Sound Board** - `lib/sound_board_screen.dart`
2. **Wiki List** - `lib/wiki_list_screen.dart`

---

## 🚀 Quick Integration Steps

### Step 1: Choose a Video Ads Package

Recommended options:

**Option A: Google Mobile Ads (AdMob)**
```yaml
dependencies:
  google_mobile_ads: ^5.2.0
```

**Option B: Unity Ads**
```yaml
dependencies:
  unity_ads_plugin: ^0.3.13
```

**Option C: AppLovin MAX**
```yaml
dependencies:
  applovin_max: ^3.11.2
```

---

## 📝 Implementation Example (Using AdMob)

### Step 1: Add Dependency

In `pubspec.yaml`:
```yaml
dependencies:
  google_mobile_ads: ^5.2.0
```

### Step 2: Initialize Ads in main.dart

```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Mobile Ads SDK
  await MobileAds.instance.initialize();
  
  await StorageService().init();
  runApp(const MyApp());
}
```

### Step 3: Create Rewarded Ad Helper

Create `lib/services/ad_service.dart`:

```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;

  // Test Ad Unit IDs (replace with real IDs in production)
  static const String androidAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  static const String iosAdUnitId = 'ca-app-pub-3940256099942544/1712485313';

  // Get platform-specific ad unit ID
  String get adUnitId {
    if (Platform.isAndroid) {
      return androidAdUnitId;
    } else if (Platform.isIOS) {
      return iosAdUnitId;
    }
    return androidAdUnitId;
  }

  // Load rewarded ad
  Future<void> loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isAdLoaded = true;
          print('Rewarded ad loaded');
        },
        onAdFailedToLoad: (error) {
          _isAdLoaded = false;
          print('Failed to load rewarded ad: $error');
        },
      ),
    );
  }

  // Show rewarded ad
  Future<bool> showRewardedAd() async {
    if (!_isAdLoaded || _rewardedAd == null) {
      print('Rewarded ad not ready');
      return false;
    }

    bool adWatched = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _isAdLoaded = false;
        loadRewardedAd(); // Load next ad
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _isAdLoaded = false;
        loadRewardedAd();
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        adWatched = true;
        print('User earned reward: ${reward.amount}');
      },
    );

    return adWatched;
  }

  void dispose() {
    _rewardedAd?.dispose();
  }
}
```

### Step 4: Update Sound Board Screen

In `lib/sound_board_screen.dart`, find the `_showUnlockDialog` method and update:

```dart
void _showUnlockDialog(BuildContext context, int index) {
  final appState = context.read<AppStateProvider>();
  final adService = AdService(); // Or inject via Provider

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Unlock Sound', style: GoogleFonts.luckiestGuy()),
      content: const Text(
        'Watch a video ad to unlock this sound?',
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(ctx); // Close dialog
            
            // Show loading
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Loading ad...')),
            );
            
            // Load and show ad
            await adService.loadRewardedAd();
            final adWatched = await adService.showRewardedAd();
            
            if (adWatched) {
              // User watched the ad - unlock the sound
              await appState.unlockSound(index);
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sound unlocked!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } else {
              // User didn't watch the ad
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please watch the ad to unlock'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            }
          },
          child: const Text('Watch Ad'),
        ),
      ],
    ),
  );
}
```

### Step 5: Update Wiki List Screen

Apply the same changes to `lib/wiki_list_screen.dart` in the `_showUnlockDialog` method.

---

## 🔍 What to Look For

### Current Implementation

The unlock methods are in `lib/providers/app_state_provider.dart`:

```dart
// Sound unlock - Line ~38
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

// Wiki unlock - Line ~57
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
```

---

## ⚠️ Important Notes

### 1. Ad Unit IDs
- Use **test ad unit IDs** during development
- Replace with **real ad unit IDs** from AdMob dashboard before release

### 2. Platform Setup

**Android** - Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<manifest>
    <application>
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
    </application>
</manifest>
```

**iOS** - Add to `ios/Runner/Info.plist`:
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy</string>
```

### 3. Privacy Policy
- Video ads require a privacy policy
- Add privacy policy URL in app store listings
- Add consent management for GDPR/CCPA compliance

---

## 🧪 Testing

### Test Flow:
1. Run app in debug mode
2. Go to Sound Board or Wiki
3. Tap locked item
4. Dialog appears: "Watch ad to unlock"
5. Tap "Watch Ad"
6. Test ad plays (AdMob provides test ads)
7. After watching, content unlocks
8. **RESTART APP** - verify unlock persisted!

---

## 📊 Current App Flow

```
User taps locked item
    ↓
Dialog shows: "Watch ad to unlock?"
    ↓
User taps "Watch Ad"
    ↓
[YOUR FRIEND ADDS VIDEO AD HERE]
    ↓
Ad plays
    ↓
User watches ad
    ↓
Ad completes (reward earned)
    ↓
Call: appState.unlockSound(index)
    ↓
Content unlocked & saved to storage
    ↓
Show success message
```

---

## 🎯 Integration Checklist

- [ ] Choose video ads platform (AdMob, Unity, etc.)
- [ ] Add dependency to `pubspec.yaml`
- [ ] Initialize ads in `main.dart`
- [ ] Create ad service/helper class
- [ ] Get ad unit IDs from platform dashboard
- [ ] Update `sound_board_screen.dart` dialog
- [ ] Update `wiki_list_screen.dart` dialog
- [ ] Test with test ad unit IDs
- [ ] Add platform-specific config (Android/iOS)
- [ ] Test on real devices
- [ ] Replace with production ad unit IDs
- [ ] Add privacy policy
- [ ] Test unlock persistence after restart
- [ ] Submit to app stores

---

## 💡 Alternative Approach (Simpler)

If you want to keep the unlock logic in the Provider:

1. Create an `AdService` class
2. Inject it into `AppStateProvider`
3. Modify unlock methods:

```dart
Future<bool> unlockSound(int index) async {
  if (_unlockedSounds.contains(index)) {
    return true;
  }

  // Show video ad
  bool adWatched = await _adService.showRewardedAd();
  
  if (!adWatched) {
    return false; // User didn't watch ad
  }

  // User watched ad - unlock
  _unlockedSounds.add(index);
  await _storage.unlockSound(index);
  notifyListeners();
  return true;
}
```

---

## 📚 Resources

### AdMob
- Setup: https://developers.google.com/admob/flutter/quick-start
- Rewarded Ads: https://developers.google.com/admob/flutter/rewarded

### Unity Ads
- Documentation: https://docs.unity.com/ads/

### AppLovin
- Flutter Plugin: https://pub.dev/packages/applovin_max

---

## 🐛 Common Issues

### Issue: Ads not showing
**Solution:** 
- Check ad unit IDs
- Verify platform initialization
- Check internet connection
- Ensure test device is registered

### Issue: Ads show but unlock doesn't work
**Solution:**
- Check `onUserEarnedReward` callback
- Verify unlock method is called after reward
- Check for async/await issues

### Issue: Unlocks don't persist
**Solution:**
- Already handled! Storage is implemented
- Just call `appState.unlockSound(index)` after ad

---

## ✅ What's Already Done (No Need to Change)

✅ Persistent storage (SharedPreferences)
✅ State management (Provider)
✅ Unlock methods in AppStateProvider
✅ UI for locked/unlocked items
✅ Dialog prompts
✅ Success/error messages
✅ Data persistence across app restarts

**You only need to:**
1. Add video ads package
2. Show ads before unlocking
3. Call the unlock method after ad is watched

---

## 🎉 Summary

The app is **100% ready** for video ads. Your friend just needs to:

1. Add a video ads SDK
2. Show ads in the two dialog methods
3. Call the unlock methods after ads complete

All persistence, state management, and UI is already implemented!

---

**Good luck with the integration!** 🚀

If you need help, all the unlock logic is in:
- `lib/providers/app_state_provider.dart` (unlock methods)
- `lib/sound_board_screen.dart` (sound unlock dialog)
- `lib/wiki_list_screen.dart` (wiki unlock dialog)