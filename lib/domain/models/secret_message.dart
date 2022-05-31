import 'package:equatable/equatable.dart';

class SecretMessage extends Equatable {
  final String message;
  final String recipientPublicKey;

  const SecretMessage({
    required this.message,
    required this.recipientPublicKey,
  });

  @override
  List<Object?> get props => [
        message,
        recipientPublicKey,
      ];
}
