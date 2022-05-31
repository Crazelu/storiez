import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:storiez/presentation/resources/palette.dart';
import 'package:storiez/presentation/shared/shared.dart';

class AddMessageView extends StatefulWidget {
  const AddMessageView({Key? key}) : super(key: key);

  @override
  _AddMessageViewState createState() => _AddMessageViewState();
}

class _AddMessageViewState extends State<AddMessageView> {
  final _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
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
                  suffix: GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      PhosphorIcons.paper_plane_right,
                      color: Palette.lightGreen,
                    ),
                  ),
                ),
                const Gap(32),
                CustomText.heading4(text: "Choose recipient"),
                const Gap(16),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (_, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: Palette.primaryColor,
                          child: CustomText.heading4(
                            text: "CR",
                            color: Palette.primaryColorLight,
                          ),
                        ),
                        title: CustomText.regular(text: "Some user"),
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
