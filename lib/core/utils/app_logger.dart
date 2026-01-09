import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import '../../config/env/env_config.dart';

/// Application-wide logger utility that respects environment settings.
/// Logging is automatically disabled in production builds.
class AppLogger {
  static bool _initialized = false;
  static bool _enableLogging = true;

  AppLogger._();

  /// Initialize the logger with optional override for logging enabled state.
  /// If not provided, it will use the environment configuration.
  static void init({bool? enableLogging}) {
    if (_initialized) return;

    if (enableLogging != null) {
      _enableLogging = enableLogging;
    } else if (AppConfig.isInitialized) {
      _enableLogging = AppConfig.instance.enableLogging;
    } else {
      // Default to enabling logs in debug mode only
      _enableLogging = kDebugMode;
    }

    _initialized = true;
  }

  /// Check if logging is enabled
  static bool get isEnabled => _enableLogging && kDebugMode;

  /// Log a debug message
  static void debug(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      message,
      level: _LogLevel.debug,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log an info message
  static void info(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      message,
      level: _LogLevel.info,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a warning message
  static void warning(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      message,
      level: _LogLevel.warning,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log an error message
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      message,
      level: _LogLevel.error,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a network request
  static void network(
    String message, {
    String? url,
    String? method,
    int? statusCode,
  }) {
    if (!isEnabled) return;

    final buffer = StringBuffer('[NETWORK]');
    if (method != null) buffer.write(' $method');
    if (url != null) buffer.write(' $url');
    if (statusCode != null) buffer.write(' ($statusCode)');
    buffer.write(': $message');

    _log(buffer.toString(), level: _LogLevel.info, tag: 'Network');
  }

  /// Log analytics events (only logs in debug, actual analytics handled separately)
  static void analytics(String event, {Map<String, dynamic>? parameters}) {
    if (!isEnabled) return;

    final paramString = parameters != null ? ' $parameters' : '';
    _log('EVENT: $event$paramString', level: _LogLevel.info, tag: 'Analytics');
  }

  /// Internal logging method
  static void _log(
    String message, {
    required _LogLevel level,
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!isEnabled) return;

    final prefix = tag != null ? '[$tag] ' : '';
    final levelPrefix = '[${level.name.toUpperCase()}]';
    final formattedMessage = '$levelPrefix $prefix$message';

    // Use developer.log for better debugging experience
    developer.log(
      formattedMessage,
      name: 'BrainrotQuiz',
      error: error,
      stackTrace: stackTrace,
      level: level.value,
    );

    // Also print to console in debug mode for convenience
    if (kDebugMode) {
      final errorString = error != null ? '\nError: $error' : '';
      final stackString = stackTrace != null ? '\nStack: $stackTrace' : '';
      debugPrint('$formattedMessage$errorString$stackString');
    }
  }
}

/// Internal log level enum
enum _LogLevel {
  debug(500),
  info(800),
  warning(900),
  error(1000);

  final int value;
  const _LogLevel(this.value);
}
