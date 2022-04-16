import 'package:throtty/models/api/error/api_error_type.dart';
import 'package:throtty/utils/logger.dart';

class ParserUtil<T> {
  static DateTime parseJsonDate(String? dateString) {
    try {
      return DateTime.parse(dateString!);
    } catch (e) {
      return DateTime.now();
    }
  }

  static String parseJsonString(
    Object? json,
    String param, {
    String? defaultValue,
  }) {
    try {
      json = json as Map;
      Object? result = json[param];

      if (result == null) return defaultValue ?? '';

      String resultString = result.toString();
      final parsedString =
          resultString.isEmpty ? defaultValue ?? resultString : resultString;

      return parsedString;
    } catch (e) {
      AppLogger.log(e);

      return defaultValue ?? '';
    }
  }

  static ApiErrorType parseApiErrorCode(Map? json) {
    try {
      String code = json!["code"];

      switch (code) {
        case "EMAIL_NOT_VERIFIED":
          return ApiErrorType.unverifiedEmail;
        default:
          return ApiErrorType.unknown;
      }
    } catch (e) {
      return ApiErrorType.unknown;
    }
  }

  static bool parseJsonBoolean(Map? json, String param) {
    try {
      Object? result = json![param];

      if (result == null) return false;
      return result as bool;
    } catch (e) {
      return false;
    }
  }

  List<T> parseJsonList({
    required List<dynamic>? json,
    required T Function(Map<String, dynamic> json) fromJson,
  }) {
    try {
      final data = List<Map<String, dynamic>>.from(json!);

      return List<T>.from(
        data.map(
          (e) => fromJson(e),
        ),
      );
    } catch (e) {
      AppLogger.log(e);
      return [];
    }
  }

  static num parseJsonNum(Map? json, String param) {
    try {
      Object? result = json![param];

      if (result == null) return 0;
      return result as num;
    } catch (e) {
      AppLogger.log(e);
      return 0;
    }
  }

  static String formatItemCount(dynamic count, String title) {
    try {
      String suffix = "s";
      if (title == title.toUpperCase()) suffix = suffix.toUpperCase();

      final itemCount = int.parse("$count");

      if (itemCount == 1) return "$itemCount $title";

      return "${formatLargeNumber("$itemCount")} $title$suffix";
    } catch (e) {
      AppLogger.log(e);
      return "";
    }
  }

  static String formatLargeNumber(String number) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return number.replaceAllMapped(reg, (Match match) => '${match[1]},');
  }
}
