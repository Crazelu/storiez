import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/domain/models/secret_message.dart';
import 'package:storiez/presentation/resources/palette.dart';
import 'package:storiez/presentation/routes/routes.dart';
import 'package:storiez/presentation/shared/shared.dart';
import 'package:storiez/presentation/views/new_story/new_story_view_model.dart';

class NewStoryView extends StatefulWidget {
  final File image;

  const NewStoryView({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  _NewStoryViewState createState() => _NewStoryViewState();
}

class _NewStoryViewState extends State<NewStoryView> {
  final _captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      onWillPop: () {
        Navigator.of(context).pop();
      },
      backgroundColor: Palette.primaryColor,
      builder: (_) {
        return SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox.expand(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            PhosphorIcons.x,
                            size: 24,
                            color: Palette.primaryColorLight,
                          ),
                        ),
                        Consumer(builder: (_, ref, __) {
                          return CustomButton(
                            width: 100,
                            buttonText: "Add secret message",
                            onPressed: () async {
                              final secretMessage = await Navigator.of(context)
                                  .pushNamed(Routes.addMessageViewRoute);

                              if (secretMessage is SecretMessage) {
                                ref.read(newStoryViewModelProvider).uploadStory(
                                      image: widget.image,
                                      caption: _captionController.text,
                                      recipientPublicKey:
                                          secretMessage.recipientPublicKey,
                                      secretMessage: secretMessage.message,
                                      recipientId: secretMessage.recipientId,
                                    );
                              }
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(widget.image),
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 86,
                            child: CustomTextField(
                              maxLength: 100,
                              fillColor: Palette.primaryColorLight,
                              controller: _captionController,
                              borderRadius: 30,
                              hint: "Add a caption...",
                            ),
                          ),
                        ),
                        const Gap(8),
                        Consumer(builder: (_, ref, __) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: FloatingActionButton(
                              backgroundColor: Palette.lightGreen,
                              onPressed: () {
                                ref.read(newStoryViewModelProvider).uploadStory(
                                      image: widget.image,
                                      caption: _captionController.text,
                                    );
                              },
                              child: const RotatedBox(
                                quarterTurns: 1,
                                child: Icon(
                                  PhosphorIcons.paper_plane_bold,
                                  color: Palette.primaryColorLight,
                                ),
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                  const Gap(8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
