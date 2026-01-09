import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../config/env/env_config.dart';
import '../core/utils/app_logger.dart';

class RewardedAdManager {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;

  /// Get the rewarded ad unit ID from environment configuration
  String get _adUnitId {
    if (AppConfig.isInitialized) {
      return AppConfig.instance.adRewardedUnitId;
    }
    // Fallback to test ad unit ID
    return 'ca-app-pub-3940256099942544/5224354917';
  }

  /// Load a rewarded ad
  void loadRewardedAd({required VoidCallback onAdLoaded}) {
    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          AppLogger.info('Rewarded ad loaded successfully', tag: 'Ads');
          _rewardedAd = ad;
          _isAdLoaded = true;
          onAdLoaded();
        },
        onAdFailedToLoad: (error) {
          AppLogger.error(
            'Rewarded ad failed to load: ${error.message}',
            tag: 'Ads',
            error: error,
          );
          _isAdLoaded = false;
        },
      ),
    );
  }

  /// Show the rewarded ad and handle callbacks
  void showRewardedAd({
    required BuildContext context,
    required VoidCallback onRewarded,
    required VoidCallback onAdClosed,
  }) {
    if (_rewardedAd == null || !_isAdLoaded) {
      AppLogger.warning('Rewarded ad is not ready yet', tag: 'Ads');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('โฆษณายังไม่พร้อม กรุณารอสักครู่')),
      );
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        AppLogger.info('Rewarded ad showed full screen', tag: 'Ads');
      },
      onAdDismissedFullScreenContent: (ad) {
        AppLogger.info('Rewarded ad dismissed', tag: 'Ads');
        ad.dispose();
        _isAdLoaded = false;
        onAdClosed();
        // Preload the next ad
        loadRewardedAd(onAdLoaded: () {});
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        AppLogger.error(
          'Rewarded ad failed to show: ${error.message}',
          tag: 'Ads',
          error: error,
        );
        ad.dispose();
        _isAdLoaded = false;
        onAdClosed();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        AppLogger.info(
          'User earned reward: ${reward.amount} ${reward.type}',
          tag: 'Ads',
        );
        onRewarded();
      },
    );
  }

  /// Dispose the ad object
  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isAdLoaded = false;
  }

  /// Check if the ad is ready to show
  bool get isAdReady => _isAdLoaded && _rewardedAd != null;
}
