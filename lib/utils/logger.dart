import 'dart:developer' as dev;

class Logger {
  final Type name;

  Logger(this.name);

  void log(Object? e) {
    AppLogger.log('''
${'🚩' * 30}
From: $name
Message: $e
''');
  }
}

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
