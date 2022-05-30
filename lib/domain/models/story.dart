import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:storiez/domain/models/user.dart';

class Story extends Equatable {
  final String imageUrl;
  final String caption;
  final Map<String, String> secretMessage;
  final AppUser poster;
  final DateTime uploadTime;

  const Story({
    required this.imageUrl,
    required this.poster,
    required this.uploadTime,
    this.caption = "",
    this.secretMessage = const {},
  });

  factory Story.fromMap(Map<String, dynamic> data) {
    return Story(
      poster: AppUser.fromMap(jsonDecode(data["poster"] ?? "")),
      imageUrl: data["imageUrl"] ?? "",
      caption: data["caption"] ?? "",
      uploadTime: DateTime.tryParse(data["uploadTime"] ?? "") ?? DateTime.now(),
    );
  }

  Story copyWith({Map<String, String>? secretMessage}) {
    return Story(
      poster: poster,
      imageUrl: imageUrl,
      caption: caption,
      uploadTime: uploadTime,
      secretMessage: secretMessage ?? this.secretMessage,
    );
  }

  Map<String, String> toMap() => {
        "poster": jsonEncode(poster.toMap()),
        "imageUrl": imageUrl,
        "caption": caption,
        "uploadTime": uploadTime.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        poster,
        imageUrl,
        caption,
        secretMessage,
        uploadTime,
      ];
}
