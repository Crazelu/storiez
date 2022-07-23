import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storiez/domain/models/secret_message.dart';
import 'package:storiez/domain/models/user.dart';
import 'package:storiez/handlers/snack_bar_handler.dart';
import 'package:storiez/presentation/resources/palette.dart';
import 'package:storiez/presentation/shared/shared.dart';
import 'package:storiez/presentation/views/add_message/add_message_view_model.dart';
import 'package:storiez/utils/locator.dart';

class AddMessageView extends StatefulWidget {
  const AddMessageView({Key? key}) : super(key: key);

  @override
  _AddMessageViewState createState() => _AddMessageViewState();
}

class _AddMessageViewState extends State<AddMessageView> {
  final ValueNotifier<AppUser?> _recipient = ValueNotifier(null);
  final _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      onWillPop: () {
        Navigator.of(context).pop();
      },
      appBar: AppBar(
        title: const Text("Add secret message"),
      ),
      builder: (size) {
        return SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const Gap(48),
                CustomTextField(
                  controller: _messageController,
                  hint: "Start typing ...",
                  textInputAction: TextInputAction.newline,
                  maxLines: 2,
                ),
                const Gap(32),
                ValueListenableBuilder<AppUser?>(
                  valueListenable: _recipient,
                  builder: (_, recipient, __) {
                    if (recipient == null) {
                      return const SizedBox();
                    }
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText.heading3(text: recipient.username),
                            CustomButton(
                              width: 100,
                              height: 40,
                              buttonText: "Send",
                              onPressed: () {
                                if (_messageController.text.isEmpty) {
                                  locator<SnackbarHandler>().showErrorSnackbar(
                                    "Add a secret message to continue",
                                  );
                                } else {
                                  Navigator.of(context).pop(
                                    SecretMessage(
                                      message: _messageController.text,
                                      recipientPublicKey: recipient.publicKey,
                                      recipientId: recipient.id,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const Gap(32),
                      ],
                    );
                  },
                ),
                CustomText.heading4(text: "Choose recipient"),
                const Gap(16),
                Expanded(
                  child: Consumer(
                    builder: (_, ref, __) {
                      final loading =
                          ref.watch(addMessageViewModelProvider).loading;
                      final users =
                          ref.watch(addMessageViewModelProvider).users;
                      if (loading && users.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 32),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (_, index) {
                          final user = users[index];
                          return ListTile(
                            onTap: () {
                              _recipient.value = user;
                            },
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Palette.lightGreen,
                              child: CustomText.heading4(
                                text: user.initials,
                                color: Palette.primaryColorLight,
                              ),
                            ),
                            title: CustomText.heading4(text: user.username),
                            subtitle: CustomText.regular(text: user.email),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
