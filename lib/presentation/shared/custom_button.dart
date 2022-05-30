import 'package:flutter/material.dart';
import 'package:storiez/presentation/resources/palette.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final double? fontSize;
  final double width;
  final double height;
  final bool active;
  final FontWeight fontWeight;
  final bool loading;

  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.active = true,
    this.loading = false,
    this.width = 385,
    this.height = 52,
    this.fontSize,
    this.fontWeight = FontWeight.w500,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        splashFactory: InkRipple.splashFactory,
        textStyle: MaterialStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: fontSize ?? 15,
            fontWeight: fontWeight,
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => active
              ? Palette.primaryColor
              : Palette.primaryColor.withOpacity(.65),
        ),
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) => Palette.primaryColorLight,
        ),
        fixedSize: MaterialStateProperty.resolveWith(
          (states) => Size(width, height),
        ),
      ),
      onPressed: () {
        if (active && !loading) onPressed();
      },
      child: loading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  Palette.primaryColorLight,
                ),
              ),
            )
          : Text(buttonText),
    );
  }
}
