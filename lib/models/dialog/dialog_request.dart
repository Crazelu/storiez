class DialogRequest {
  final DialogType dialogType;
  final String message;
  final bool autoDismiss;
  final Duration duration;

  DialogRequest({
    this.dialogType = DialogType.error,
    required this.message,
    this.autoDismiss = false,
    this.duration = const Duration(seconds: 3),
  });
}

enum DialogType { success, info, error }
