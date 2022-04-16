import 'package:equatable/equatable.dart';
import 'package:throtty/models/api/error/api_error_response.dart';
import 'package:throtty/utils/parser_util.dart';

abstract class ServerResponse {}

class Success extends ServerResponse with EquatableMixin {
  final Map<String, dynamic> data;

  Success(this.data);

  @override
  List<Object?> get props => [data];
}

class Failure extends ServerResponse with EquatableMixin {
  final ApiErrorResponse error;

  Failure(this.error);

  factory Failure.fromMap(Map<String, dynamic> json) {
    return Failure(
      ApiErrorResponse(
        message: getErrorMessage(json['message']),
        type: ParserUtil.parseApiErrorCode(json),
      ),
    );
  }

  static String getErrorMessage(Object message) {
    if (message is List<String> && message.isNotEmpty) {
      return message.first;
    }
    if (message is String) return message;
    return "Something went wrong, try again !!!";
  }

  @override
  List<Object?> get props => [error];
}
