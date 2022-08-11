import 'package:equatable/equatable.dart';

class ApiErrorResponse extends Equatable {
  final String message;

  const ApiErrorResponse({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
