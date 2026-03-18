import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'config/env/dev_config.dart';
import 'config/env/env_config.dart';
import 'config/env/prod_config.dart';
import 'core/utils/app_logger.dart';
import 'providers/app_state_provider.dart';
import 'services/storage_service.dart';
import 'screens/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment configuration
  // - Development: use main_dev.dart entry point
  // - Staging:     use main_staging.dart entry point
  // - Production:  use main_prod.dart entry point  ← always use this for release builds!
  if (!AppConfig.isInitialized) {
    // Default to ProdConfig so accidental builds from main.dart are safe
    AppConfig.init(ProdConfig());
  }

  // Initialize logger based on environment
  AppLogger.init();
  AppLogger.info(
    'Starting app in ${AppConfig.instance.environment.name.toUpperCase()} mode',
  );

  // Initialize storage service
  await StorageService().init();

  // Initialize Mobile Ads
  await MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppStateProvider()..loadFromStorage(),
        ),
      ],
      child: MaterialApp(
        title: config.appName,
        debugShowCheckedModeBanner: config.showDebugBanner,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
