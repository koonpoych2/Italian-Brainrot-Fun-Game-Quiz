import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'config/env/env_config.dart';
import 'config/env/prod_config.dart';
import 'core/utils/app_logger.dart';
import 'providers/app_state_provider.dart';
import 'services/storage_service.dart';
import 'screens/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize production configuration
  AppConfig.init(ProdConfig());

  // Initialize services
  await StorageService().init();
  await MobileAds.instance.initialize();

  // Disable logging in production
  AppLogger.init(enableLogging: false);

  runApp(const BrainrotQuizApp());
}

class BrainrotQuizApp extends StatelessWidget {
  const BrainrotQuizApp({super.key});

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
