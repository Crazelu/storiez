import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/domain/models/story.dart';
import 'package:storiez/presentation/resources/palette.dart';
import 'package:storiez/presentation/shared/shared.dart';
import 'package:storiez/presentation/views/home/home_view_model.dart';
import 'package:storiez/presentation/views/story/story_view_model.dart';

class StoryView extends StatelessWidget {
  final Story story;

  StoryView({
    Key? key,
    required this.story,
  }) : super(key: key);

  final storyViewModelProvider =
      ChangeNotifierProvider((_) => StoryViewModel());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: size.height,
        minHeight: size.height,
        minWidth: size.width,
        maxWidth: size.width,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: story.imageUrl,
            placeholder: (_, __) =>
                const Center(child: CircularProgressIndicator.adaptive()),
            errorWidget: (_, __, ___) {
              return const Center(
                child: Icon(PhosphorIcons.image),
              );
            },
          ),
          Positioned.fill(
            bottom: size.height - 160,
            child: Consumer(builder: (_, ref, __) {
              final viewModel = ref.read(storyViewModelProvider);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder<bool>(
                    future: viewModel.hasSecret(story),
                    builder: (_, snapshot) {
                      if (snapshot.hasData && snapshot.data == true) {
                        return GestureDetector(
                          onTap: () {
                            viewModel.showSecret(story);
                          },
                          child: const Icon(
                            PhosphorIcons.lock_key_open,
                            size: 24,
                            color: Palette.primaryColorLight,
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  Consumer(builder: (_, ref, __) {
                    final user = ref.watch(storyViewModelProvider).user;

                    if (user?.id == story.poster.id) {
                      return GestureDetector(
                        onTap: () {
                          viewModel.deleteStory(story);
                          ref
                              .read(homeViewModelProvider)
                              .subscribeToStoriesStream();
                        },
                        child: const Icon(
                          PhosphorIcons.trash_simple,
                          size: 24,
                          color: Palette.faintRed,
                        ),
                      );
                    }
                    return const SizedBox();
                  }),
                ],
              );
            }),
          ),
          Positioned.fill(
            top: size.height * .7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomText.regular(
                text: story.caption,
                color: Palette.primaryColorLight.withOpacity(.9),
              ),
            ),
          )
        ],
      ),
    );
  }
}
