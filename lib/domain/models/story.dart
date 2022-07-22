import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:storiez/domain/models/user.dart';

class Story extends Equatable {
  final String id;
  final String imageUrl;
  final String caption;
  final Map<String, String> secretMessage;
  final AppUser poster;
  final DateTime uploadTime;

  const Story({
    this.id = "",
    required this.imageUrl,
    required this.poster,
    required this.uploadTime,
    this.caption = "",
    this.secretMessage = const {},
  });

  factory Story.fromMap(
    Map<String, dynamic> data, [
    String id = "",
  ]) {
    return Story(
      poster: AppUser.fromMap(jsonDecode(data["poster"] ?? "")),
      id: id,
      imageUrl: data["imageUrl"] ?? "",
      caption: data["caption"] ?? "",
      uploadTime: DateTime.tryParse(data["uploadTime"] ?? "") ?? DateTime.now(),
    );
  }

  Story copyWith({Map<String, String>? secretMessage}) {
    return Story(
      id: id,
      poster: poster,
      imageUrl: imageUrl,
      caption: caption,
      uploadTime: uploadTime,
      secretMessage: secretMessage ?? this.secretMessage,
    );
  }

  Map<String, String> toMap([bool withId = false]) => {
        if (withId) "id": id,
        "poster": jsonEncode(poster.toMap()),
        "imageUrl": imageUrl,
        "caption": caption,
        "uploadTime": uploadTime.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        poster,
        imageUrl,
        caption,
        secretMessage,
        uploadTime,
      ];
}
