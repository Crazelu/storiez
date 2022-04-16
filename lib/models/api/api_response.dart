import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:throtty/models/api/server_response.dart';
import 'package:throtty/models/api/error/api_error_response.dart';
import 'package:throtty/utils/parser_util.dart';

class ApiResponse<T> extends Equatable {
  final bool success;
  final String message;
  final ApiErrorResponse? error;
  final T? data;

  const ApiResponse({
    this.success = false,
    this.message = '',
    this.error,
    this.data,
  });

  factory ApiResponse.fromJson(
    Either<Failure, Success> json, {
    T Function(Map<String, dynamic> json)? parseJson,
    String Function(Map<String, dynamic> json)? parseMessage,
  }) {
    return json.fold(
      (failure) => ApiResponse(error: failure.error),
      (success) => ApiResponse(
        success: true,
        message: parseMessage != null
            ? parseMessage(success.data)
            : ParserUtil.parseJsonString(success.data, 'message'),
        data:
            parseJson != null ? parseJson(success.data) : success.data['data'],
      ),
    );
  }

  @override
  List<Object?> get props => [
        success,
        message,
        error,
      ];
}
