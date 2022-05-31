import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:storiez/domain/models/asset_image.dart' as c;
import 'package:storiez/presentation/resources/palette.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({
    Key? key,
    required this.asset,
    this.onSelected,
    required this.selected,
  }) : super(key: key);

  final c.AssetImage asset;
  final Function(File? file)? onSelected;
  final bool Function(File? file) selected;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  File? file;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: widget.asset.thumbData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;

        if (bytes == null) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        }

        return InkWell(
          onTap: () async {
            file = await widget.asset.file;
            setState(() {});

            widget.onSelected?.call(file);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                colorFilter: widget.selected(file)
                    ? ColorFilter.mode(
                        Colors.black.withOpacity(.2),
                        BlendMode.darken,
                      )
                    : null,
                fit: BoxFit.cover,
                image: MemoryImage(bytes),
              ),
            ),
            child: widget.selected(file)
                ? const Center(
                    child: Icon(
                      Icons.check,
                      color: Palette.primaryColorLight,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}
