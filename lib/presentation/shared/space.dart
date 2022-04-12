import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Space extends StatelessWidget {
  final double? flex;

  const Space({Key? key, this.flex: 2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool horizontal() {
      Axis? direction;
      try {
        direction = context.findAncestorWidgetOfExactType<Flex>()!.direction;
      } catch (e) {
        direction = context.findAncestorWidgetOfExactType<Scrollable>()?.axis;
      }

      return direction == Axis.horizontal;
    }

    return SizedBox(
      height: !horizontal() ? 5.h * flex! : 0,
      width: horizontal() ? 5.w * flex! : 0,
    );
  }
}
