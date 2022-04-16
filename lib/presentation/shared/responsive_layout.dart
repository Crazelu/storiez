import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget? tablet;
  final Widget mobile;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraint) {
        if (constraint.maxWidth <= 488) return mobile;

        return tablet ?? mobile;
      },
    );
  }
}
