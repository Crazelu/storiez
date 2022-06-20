import 'package:equatable/equatable.dart';

class SecretMessage extends Equatable {
  final String message;
  final String recipientPublicKey;
  final String recipientId;

  const SecretMessage({
    required this.message,
    required this.recipientPublicKey,
    required this.recipientId,
  });

  @override
  List<Object?> get props => [
        message,
        recipientPublicKey,
        recipientId,
      ];
}
