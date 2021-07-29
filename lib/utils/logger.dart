import 'package:logger/logger.dart';

class AppLogger {
  static Logger get logger => Logger(
        printer: PrettyPrinter(),
      );
}
