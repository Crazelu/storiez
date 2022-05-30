import 'package:flutter/material.dart';
import 'package:storiez/presentation/shared/shared.dart';

class TextDivider extends StatelessWidget {
  final String text;

  const TextDivider({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.black)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CustomText.heading4(
            text: text,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Expanded(child: Divider(color: Colors.black)),
      ],
    );
  }
}
