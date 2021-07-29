import 'package:flutter/material.dart';
import '../../models/dialog/dialog_request.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_spacer.dart';

class DialogCardDemo extends StatelessWidget {
  final DialogRequest request;
  final Function dismissDialog;
  const DialogCardDemo({
    Key? key,
    required this.request,
    required this.dismissDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.transparent,
      elevation: 4,
      child: Container(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(10.w),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: const Offset(1, 1),
                    color: _getBorderColor(request.dialogType),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getIcon(request.dialogType),
                        color: _getBorderColor(request.dialogType),
                      ),
                      const CustomSpacer(
                        flex: 3,
                        horizontal: true,
                      ),
                      Text(
                        "Dialog title",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  const CustomSpacer(flex: 3),
                  Text(
                    request.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const CustomSpacer(flex: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => dismissDialog(),
                        child: const Text("Got it"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(DialogType type) {
    switch (type) {
      case DialogType.error:
        return Icons.warning_amber;
      case DialogType.info:
        return Icons.info;
      default:
        return Icons.check_circle;
    }
  }

  Color _getBorderColor(DialogType type) {
    switch (type) {
      case DialogType.error:
        return const Color(0xfff36e6e);
      case DialogType.info:
        return const Color(0xff6133bd);
      default:
        return const Color(0xff07D68C);
    }
  }
}
