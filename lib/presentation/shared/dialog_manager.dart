import 'package:flutter/material.dart';
import '../../models/dialog/dialog_request.dart';
import '../../utils/utils.dart';
import '../../handlers/handlers.dart';
import 'dialog_card_demo.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  const DialogManager({Key? key, required this.child}) : super(key: key);

  @override
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  OverlayEntry? _overlayEntry;
  late DialogHandler _dialogHandler;

  @override
  void initState() {
    super.initState();
    _dialogHandler = locator<DialogHandler>();
    _dialogHandler.registerDialogListener(_showDialog);
    _dialogHandler.registerDismissDialogListener(_dismissDialog);
  }

  void _showDialog(DialogRequest request) {
    _overlayEntry = _createOverlayEntry(request);
    if (_overlayEntry != null) {
      Overlay.of(context)!.insert(_overlayEntry!);

      //dismiss dialog after [duration] if [autoDismiss] is true
      if (request.autoDismiss) {
        Future.delayed(request.duration).then((value) => _dismissDialog());
      }
    }
  }

  void _dismissDialog() {
    if (_overlayEntry != null) {
      _dialogHandler.dialogComplete(true);
      _overlayEntry!.remove();
    }
  }

  OverlayEntry _createOverlayEntry(DialogRequest request) {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: context.screenWidth(),
        child: DialogCardDemo(
          request: request,
          dismissDialog: () => _dismissDialog(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
