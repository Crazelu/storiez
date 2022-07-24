import 'package:flutter/material.dart';
import 'package:storiez/presentation/resources/palette.dart';

class IndicatorRow extends StatelessWidget {
  final int length;
  final int activeIndex;

  const IndicatorRow({
    Key? key,
    required this.length,
    required this.activeIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < length; i++)
          _Indicator(
            active: i <= activeIndex,
            width: (width / length) - 10,
            margin: i == length - 1 ? 0 : 10,
          )
      ],
    );
  }
}

class _Indicator extends StatelessWidget {
  final bool active;
  final double width;
  final double margin;

  const _Indicator({
    Key? key,
    required this.active,
    required this.width,
    this.margin = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      width: width,
      margin: EdgeInsets.only(right: margin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * .3),
        color: active ? Palette.primaryColorLight : Palette.inactiveColor,
      ),
    );
  }
}
