import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget Function(Size size) builder;
  final Color? backgroundColor;
  final AppBar? appBar;
  final Drawer? drawer;
  final bool resizeToAvoidBottomInset;
  final Function? onWillPop;
  final Function? onTap;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const ResponsiveWidget({
    Key? key,
    required this.builder,
    this.appBar,
    this.drawer,
    this.backgroundColor,
    this.onWillPop,
    this.onTap,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      Size constraints = Size(constraint.maxWidth, constraint.maxHeight);
      return WillPopScope(
        onWillPop: () {
          if (onWillPop != null) {
            onWillPop!();
          } else {
            Navigator.of(context).pop();
          }
          return Future.value(false);
        },
        child: GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
          },
          child: Scaffold(
            floatingActionButton: floatingActionButton,
            bottomNavigationBar: bottomNavigationBar,
            backgroundColor:
                backgroundColor ?? Theme.of(context).backgroundColor,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            appBar: appBar,
            drawer: drawer,
            body: Builder(
              builder: (_) => builder(constraints),
            ),
          ),
        ),
      );
    });
  }
}
