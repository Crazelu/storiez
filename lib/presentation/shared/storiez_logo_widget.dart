import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class StoriezLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final Color? textColor;
  final bool withText;
  final double spacing;
  final double textSize;

  const StoriezLogo({
    Key? key,
    this.withText = true,
    this.size = 70,
    this.spacing = 8,
    this.textSize = 16,
    this.color,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "S.",
          style: GoogleFonts.syncopate(
            textStyle: Theme.of(context).textTheme.headline5?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: size,
                  color: color ?? Colors.black.withOpacity(.6),
                ),
          ),
        ),
        if (withText) ...{
          Gap(spacing),
          Text(
            "Storiez",
            style: GoogleFonts.syncopate(
              textStyle: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: textSize,
                    color: textColor,
                  ),
            ),
          ),
        },
      ],
    );
  }
}
