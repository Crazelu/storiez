import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String email;
  final String username;
  final String publicKey;

  const AppUser({
    required this.id,
    required this.email,
    required this.username,
    required this.publicKey,
  });

  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      id: data["id"] ?? "",
      email: data["email"] ?? "",
      username: data["username"] ?? "",
      publicKey: data["publicKey"] ?? "",
    );
  }

  Map<String, String> toMap() => {
        "id": id,
        "email": email,
        "username": username,
        "publicKey": publicKey,
      };

  @override
  List<Object?> get props => [
        email,
        username,
        publicKey,
      ];
}
