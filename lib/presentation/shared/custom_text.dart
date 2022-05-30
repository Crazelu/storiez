import 'package:flutter/material.dart';
import 'package:storiez/presentation/resources/text_styles.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const CustomText({
    Key? key,
    required this.text,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
  }) : super(key: key);

  factory CustomText.heading1({
    required String text,
    Color? color,
    double? fontSize,
    double? height,
  }) {
    return CustomText(
      text: text,
      style: TextStyles.heading1Style.copyWith(
        color: color,
        fontSize: fontSize,
        height: height,
      ),
    );
  }

  factory CustomText.heading2({
    required String text,
    Color? color,
    double? fontSize,
    double? height,
  }) {
    return CustomText(
      text: text,
      style: TextStyles.heading2Style.copyWith(
        color: color,
        fontSize: fontSize,
        height: height,
      ),
    );
  }

  factory CustomText.heading3({
    required String text,
    Color? color,
    double? fontSize,
    double? height,
    TextAlign? textAlign,
  }) {
    return CustomText(
      text: text,
      textAlign: textAlign,
      style: TextStyles.heading3Style.copyWith(
        color: color,
        fontSize: fontSize,
        height: height,
      ),
    );
  }

  factory CustomText.heading4({
    required String text,
    Color? color,
    double? fontSize,
    double? height,
    FontWeight? fontWeight,
    TextOverflow? overflow,
    int? maxLines,
    TextAlign? textAlign,
  }) {
    return CustomText(
      text: text,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyles.heading4Style.copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }

  factory CustomText.body({
    required String text,
    Color? color,
    double? fontSize,
    double? height,
    TextDecoration? decoration,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return CustomText(
      text: text,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyles.bodyStyle.copyWith(
        decoration: decoration,
        decorationStyle: TextDecorationStyle.solid,
        color: color,
        fontSize: fontSize,
        height: height,
        fontWeight: fontWeight,
      ),
    );
  }

  factory CustomText.regular({
    required String text,
    Color? color,
    double? fontSize,
    double? height,
    TextAlign? textAlign,
  }) {
    return CustomText(
      text: text,
      textAlign: textAlign,
      style: TextStyles.regularStyle.copyWith(
        color: color,
        fontSize: fontSize,
        height: height,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: true,
      textAlign: textAlign,
      style: style,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
