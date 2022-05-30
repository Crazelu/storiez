class Validators {
  static String? validateEmail(String? value) {
    const Pattern emailPatter =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regex = RegExp(emailPatter.toString());
    if (value!.isEmpty || !regex.hasMatch(value)) {
      return 'Please enter a valid email';
    } else {
      return null;
    }
  }

  static String? validatePassword(String? value) {
    if (value == null) return null;

    if (value.isEmpty) {
      return 'Enter password';
    }
    if (value.length < 6) {
      return 'Password must contain at least 6 characters';
    }
    return null;
  }
}
