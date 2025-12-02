import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void success(BuildContext context, String message) {
    _show(context,
        title: "Success",
        message: message,
        bg: Colors.green,
        textColor: Colors.white);
  }

  static void error(BuildContext context, String message) {
    _show(context,
        title: "Error",
        message: message,
        bg: Colors.red,
        textColor: Colors.white);
  }

  static void _show(
      BuildContext context, {
        required String title,
        required String message,
        required Color bg,
        required Color textColor,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$title: $message",
          style: TextStyle(color: textColor),
        ),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
