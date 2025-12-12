import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdManager {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;

  // โหลดโฆษณา
  void loadRewardedAd({required VoidCallback onAdLoaded}) {
    RewardedAd.load(
      // Test Rewarded Ad Unit ID
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        // เมื่อโหลดสำเร็จ
        onAdLoaded: (ad) {
          debugPrint('✅ Rewarded ad loaded successfully');
          _rewardedAd = ad;
          _isAdLoaded = true;
          onAdLoaded(); // เรียก callback เมื่อโหลดเสร็จ
        },
        // เมื่อโหลดไม่สำเร็จ
        onAdFailedToLoad: (error) {
          debugPrint('❌ Rewarded ad failed to load: $error');
          _isAdLoaded = false;
        },
      ),
    );
  }

  // แสดงโฆษณาและรับรางวัล
  void showRewardedAd({
    required BuildContext context,
    required VoidCallback onRewarded, // เมื่อได้รับรางวัล
    required VoidCallback onAdClosed, // เมื่อปิดโฆษณา
  }) {
    if (_rewardedAd == null || !_isAdLoaded) {
      debugPrint('⚠️ Rewarded ad is not ready yet');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('โฆษณายังไม่พร้อม กรุณารอสักครู่')),
      );
      return;
    }

    // ตั้งค่า callback
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      // เมื่อโฆษณาแสดงเต็มจอ
      onAdShowedFullScreenContent: (ad) {
        debugPrint('📺 Rewarded ad showed full screen');
      },
      // เมื่อโฆษณาถูกปิด
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('❌ Rewarded ad dismissed');
        ad.dispose();
        _isAdLoaded = false;
        onAdClosed(); // เรียก callback เมื่อปิดโฆษณา
        // โหลดโฆษณาใหม่สำหรับครั้งต่อไป
        loadRewardedAd(onAdLoaded: () {});
      },
      // เมื่อเกิด error
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('⚠️ Rewarded ad failed to show: $error');
        ad.dispose();
        _isAdLoaded = false;
        onAdClosed();
      },
    );

    // แสดงโฆษณา
    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        // ผู้ใช้ดูโฆษณาจนจบแล้ว ได้รับรางวัล!
        debugPrint('🎁 User earned reward: ${reward.amount} ${reward.type}');
        onRewarded(); // เรียก callback เมื่อได้รับรางวัล
      },
    );
  }

  // ทำลาย ad object
  void dispose() {
    _rewardedAd?.dispose();
  }

  // เช็คว่าโฆษณาพร้อมหรือยัง
  bool get isAdReady => _isAdLoaded && _rewardedAd != null;
}