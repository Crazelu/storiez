import 'dart:developer' as dev;

class AppLogger {
  AppLogger._();

  static bool _showLogs = false;

  static void configure({required bool showLogs}) {
    _showLogs = showLogs;
  }

  static void log(Object? e) {
    if (_showLogs) dev.log("$e");
  }
}
