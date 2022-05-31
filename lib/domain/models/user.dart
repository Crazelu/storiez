import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String docId;
  final String id;
  final String email;
  final String username;
  final String publicKey;

  const AppUser({
    required this.id,
    required this.email,
    required this.username,
    required this.publicKey,
    this.docId = "",
  });

  String get initials => username.substring(0, 2).toUpperCase();

  factory AppUser.fromMap(Map<String, dynamic> data, [String docId = ""]) {
    return AppUser(
      id: data["id"] ?? "",
      email: data["email"] ?? "",
      username: data["username"] ?? "",
      publicKey: data["publicKey"] ?? "",
      docId: docId,
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
        id,
        email,
        username,
        publicKey,
        docId,
      ];
}
