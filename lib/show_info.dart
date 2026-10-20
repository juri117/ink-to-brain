import 'package:material_ui/material_ui.dart';

void showInfo(BuildContext context, String title, String message) {
  showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text(title), content: Text(message)));
}
