import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as io;

Future<void> requestWritePermission() async {
  if (io.Platform.isAndroid || io.Platform.isIOS) {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      // print(statuses[Permission.storage]);
    }
    /*
    var statusExt = await Permission.manageExternalStorage.status;
    if (statusExt.isDenied) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      // print(statuses[Permission.storage]);
    }
  */
  }
}
