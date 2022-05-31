import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/presentation/resources/palette.dart';
import 'package:storiez/presentation/routes/routes.dart';
import 'package:storiez/presentation/shared/shared.dart';
import 'package:storiez/presentation/views/image_picker/image_picker_view_model.dart';
import 'package:storiez/presentation/views/image_picker/widgets/image_preview.dart';

class ImagePickerView extends StatefulWidget {
  const ImagePickerView({Key? key}) : super(key: key);

  @override
  State<ImagePickerView> createState() => _ImagePickerViewState();
}

class _ImagePickerViewState extends State<ImagePickerView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ProviderScope.containerOf(context)
          .read(imagePickerViewModelProvider)
          .getImages(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        backgroundColor: Palette.primaryColorLight,
        elevation: 0,
        leading: const BackButton(color: Palette.primaryColor),
      ),
      floatingActionButton: Consumer(
        builder: (_, ref, __) {
          final image = ref.watch(imagePickerViewModelProvider).selectedImage;
          if (image == null) {
            return const SizedBox();
          }
          return FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                Routes.newStoryViewRoute,
                arguments: image,
              );
            },
            child: const RotatedBox(
              quarterTurns: 1,
              child: Icon(
                PhosphorIcons.paper_plane_light,
              ),
            ),
          );
        },
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Consumer(
              builder: (_, ref, __) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1.0,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final viewModel =
                              ref.watch(imagePickerViewModelProvider);
                          final images = viewModel.images;
                          return ImagePreview(
                            asset: images[index],
                            selected: (file) {
                              return file != null &&
                                  viewModel.selectedImage == file;
                            },
                            onSelected: (file) {
                              ref
                                  .read(imagePickerViewModelProvider)
                                  .setSelectedImage(file!);
                              Navigator.of(context).pushNamed(
                                Routes.newStoryViewRoute,
                                arguments: file,
                              );
                            },
                          );
                        },
                        childCount: ref
                            .watch(imagePickerViewModelProvider)
                            .images
                            .length,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
