import 'package:flutter/material.dart';

void showInfo(context, String title, String message) {
  showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text(title), content: Text(message)));
}
