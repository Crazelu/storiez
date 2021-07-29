import 'dart:async';
import '../models/dialog/dialog_request.dart';

abstract class DialogHandler {
  void setIsDialogVisible(bool isDialogVisible);
  void dismissDialog();

  /// Registers a callback function to show the dialog
  void registerDialogListener(Function(DialogRequest) showDialogListener);
  void registerDismissDialogListener(Function dismissCurrentDialog);
  void dialogComplete(bool response);
  Future<bool> showDialog({
    DialogType type = DialogType.error,
    required String message,
    bool autoDismiss = false,
    Duration duration = const Duration(seconds: 3),
  });
}

class DialogHandlerImpl implements DialogHandler {
  late Function(DialogRequest) _showDialogListener;
  late Completer<bool> _dialogCompleter;
  late Function _dismissCurrentDialog;

  Completer<bool> get dialogCompleter => _dialogCompleter;

  bool _isDialogVisible = false;

  /// Boolean reference which can be used to look up whether a dialog is on screen or not.
  bool get isDialogVisible => _isDialogVisible;

  void setIsDialogVisible(bool isDialogVisible) {
    _isDialogVisible = isDialogVisible;
  }

  void registerDialogListener(Function(DialogRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  /// Registers a callback function to dismiss the dialog
  void registerDismissDialogListener(Function dismissCurrentDialog) {
    _dismissCurrentDialog = dismissCurrentDialog;
  }

  /// Dismisses the dialog
  void dismissDialog() {
    _dismissCurrentDialog();
  }

  ///Dismisses any visible dialog
  void _closeVisibleDialog() {
    if (isDialogVisible) {
      dismissDialog();
    }
  }

  /// Calls the dialog listener and returns a Future that will wait for dialogComplete.
  Future<bool> showDialog({
    DialogType type = DialogType.error,
    required String message,
    bool autoDismiss = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    _dialogCompleter = Completer<bool>();
    _closeVisibleDialog();
    _showDialogListener(
      DialogRequest(
        message: message,
        dialogType: type,
        duration: duration,
        autoDismiss: autoDismiss,
      ),
    );

    _isDialogVisible = true;
    return _dialogCompleter.future;
  }

  /// Completes the _dialogCompleter to resume the Future's execution call
  void dialogComplete(bool response) {
    _isDialogVisible = false;
    _dialogCompleter.complete(response);
    _dialogCompleter = Completer<bool>();
  }
}
