import 'dart:io';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';

class AssetImage extends Equatable {
  final Future<File?> file;
  final Future<Uint8List?> thumbData;

  const AssetImage({
    required this.file,
    required this.thumbData,
  });

  @override
  List<Object?> get props => [file, thumbData];
}
