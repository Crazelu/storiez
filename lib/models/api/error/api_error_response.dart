import 'package:equatable/equatable.dart';
import 'package:throtty/models/api/error/api_error_type.dart';

class ApiErrorResponse extends Equatable {
  final ApiErrorType type;
  final String message;

  const ApiErrorResponse({
    this.type = ApiErrorType.unknown,
    required this.message,
  });

  @override
  List<Object?> get props => [type, message];
}
