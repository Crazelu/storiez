import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSpacer extends StatelessWidget {
  final bool? horizontal;
  final double? flex;

  const CustomSpacer({Key? key, this.horizontal: false, this.flex: 2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: !horizontal! ? 5.h * flex! : 0,
      width: horizontal! ? 5.w * flex! : 0,
    );
  }
}
