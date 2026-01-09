import 'package:flutter/material.dart';

import '../../home_screen.dart';
import '../../models/options.dart';
import '../../screens/splash_screen/splash_screen.dart';
import '../../sound_board_screen.dart';
import '../../wiki_detail_screen.dart';
import '../../wiki_list_screen.dart';

/// Application route names
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String home = '/home';
  static const String quiz = '/quiz';
  static const String quizResult = '/quiz/result';
  static const String soundBoard = '/sound-board';
  static const String wikiList = '/wiki';
  static const String wikiDetail = '/wiki/detail';
  static const String settings = '/settings';
}

/// Application route generator
class AppRouter {
  AppRouter._();

  /// Generate route based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _buildRoute(const SplashScreen(), settings);

      case AppRoutes.home:
        return _buildRoute(const HomeScreen(), settings);

      case AppRoutes.soundBoard:
        return _buildRoute(const SoundBoardScreen(), settings);

      case AppRoutes.wikiList:
        return _buildRoute(const WikiListScreen(), settings);

      case AppRoutes.wikiDetail:
        final args = settings.arguments;
        if (args is WikiDetailArguments) {
          return _buildRoute(WikiDetailScreen(item: args.item), settings);
        }
        return _errorRoute('Invalid arguments for WikiDetail');

      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  /// Build a MaterialPageRoute with the given widget and settings
  static MaterialPageRoute<T> _buildRoute<T>(
    Widget widget,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<T>(builder: (_) => widget, settings: settings);
  }

  /// Build an error route for unknown routes
  static MaterialPageRoute<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to home
                  },
                  child: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Navigate to a named route
  static Future<T?> navigateTo<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  /// Navigate to a named route and replace current route
  static Future<T?> navigateAndReplace<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, dynamic>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate to a named route and clear the stack
  static Future<T?> navigateAndClearStack<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Pop the current route
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  /// Pop until a specific route
  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  /// Check if can pop
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }
}

/// Arguments class for WikiDetail screen
class WikiDetailArguments {
  final Options item;

  const WikiDetailArguments({required this.item});
}

/// Arguments class for Quiz screen
class QuizArguments {
  final String? categoryId;
  final String? difficulty;
  final int? questionCount;

  const QuizArguments({this.categoryId, this.difficulty, this.questionCount});
}

/// Arguments class for QuizResult screen
class QuizResultArguments {
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final Duration timeTaken;

  const QuizResultArguments({
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeTaken,
  });
}
