import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

Future<void> requestWritePermission() async {
  if (io.Platform.isAndroid || io.Platform.isIOS) {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      // Map<Permission, PermissionStatus> statuses =
      await [
        Permission.storage,
      ].request();
      // print(statuses[Permission.storage]);
    }
  }
}

Future<String?> getDbPath() async {
  if (io.Platform.isAndroid) {
    await requestWritePermission();
    final io.Directory? dir = await getExternalStorageDirectory();
    if (dir == null) {
      return null;
    }
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return path.join(dir.path, 'words.db');
  }
  if (io.Platform.isWindows) {
    final dir = io.Directory.current;
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return path.join(dir.path, 'words.db');
  }
  return null;
}
