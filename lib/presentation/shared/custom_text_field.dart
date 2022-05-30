import 'package:flutter/material.dart';

const double textFieldBorderWidth = .5;

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final Widget? suffix;
  final Function(String)? validator;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final bool readOnly;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.suffix,
    this.validator,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      readOnly: readOnly,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      cursorColor: Colors.black,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.disabled,
      keyboardType: keyboardType,
      controller: controller,
      focusNode: focusNode,
      validator: (value) {
        if (validator != null) {
          return validator!(value ?? "");
        }
        return null;
      },
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: label,
        hintText: hint,
        suffixIcon: suffix,
        labelStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Colors.black54,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black.withOpacity(.5),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black.withOpacity(.5),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black.withOpacity(.5),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
