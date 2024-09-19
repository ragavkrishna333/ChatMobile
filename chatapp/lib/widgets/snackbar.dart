import 'package:flutter/material.dart';

class Snackbarpage {
  void showSnackbar(BuildContext context, String message, Color colors) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colors,
        behavior: SnackBarBehavior.floating,
        elevation: 10.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        content: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }
}
