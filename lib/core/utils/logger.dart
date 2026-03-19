import 'dart:developer' as dev;

import 'package:demo_project/core/config/environment.dart';

class AppLogger {
  AppLogger._();

  static void log(String message, {String tag = 'APP'}) {
    if (EnvironmentConfig.isDev) {
      dev.log('[$tag] $message');
    }
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (EnvironmentConfig.isDev) {
      dev.log(
        '[ERROR] $message',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void network(String message) => log(message, tag: 'NETWORK');

  static void info(String message) => log(message, tag: 'INFO');
}
