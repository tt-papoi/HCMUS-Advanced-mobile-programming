import 'package:flutter/material.dart';
import 'package:jarvis/views/dialogs/error_dialog.dart';

class DialogUtils {
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return ErrorDialog(message: message);
      },
    );
  }
}
