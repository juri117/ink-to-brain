import 'dart:io';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ink2brain/utils/file_utils.dart';
import 'package:nextcloud/nextcloud.dart';

const nextCloudDir = "ink2brain";

Future<NextcloudClient?> ncGetClient() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // final SharedPreferences prefs = await _prefs;
  final String host = prefs.getString('nextcloud_host') ?? "";
  final String user = prefs.getString('nextcloud_user') ?? "";
  final String pw = prefs.getString('nextcloud_pw') ?? "";

  if (host == "" || user == "" || pw == "") {
    return null;
  }

  return NextcloudClient(
    Uri(host: host, scheme: 'https'),
    loginName: user,
    password: pw,
  );
}

Future<String> ncUploadFile() async {
  try {
    final String? dbPath = await getDbPath();
    if (dbPath == null) {
      //print("could not find db file path");
      return "could not find db file path";
    }

    final client = await ncGetClient();

    if (client == null) {
      //print("no nextcloud host defined");
      return "no nextcloud host defined";
    }
    try {
      await client.webdav.mkcol(PathUri.parse('/$nextCloudDir'));
    } catch (e, stacktrace) {
      print(stacktrace);
      //return "failed";
    }

    try {
      String date = DateFormat("yyyy-MM-dd_HH-mm-ss").format(DateTime.now());
      await client.webdav.copy(PathUri.parse('/$nextCloudDir/words.db'),
          PathUri.parse('/$nextCloudDir/words_old_$date.db'));
    } catch (e, stacktrace) {
      print(stacktrace);
    }
    await client.webdav.put(File(dbPath).readAsBytesSync(),
        PathUri.parse('/$nextCloudDir/words.db'));
  } on Exception catch (e, stacktrace) {
    //print(e.statusCode);
    //print(e.body);
    print(e);
    print(stacktrace);
    return "failed: $e";
  }
  return "OK";
}

Future<String> ncDownloadFile() async {
  try {
    final String? dbPath = await getDbPath();
    if (dbPath == null) {
      print("could not find db file path");
      return "could not find db file path";
    }

    final client = await ncGetClient();
    if (client == null) {
      print("no nextcloud host defined");
      return "no nextcloud host defined";
    }

    File(dbPath).writeAsBytesSync(
        await client.webdav.get(PathUri.parse('/$nextCloudDir/words.db')));
  } on Exception catch (e, stacktrace) {
    //print(e.statusCode);
    //print(e.body);
    print(e);
    print(stacktrace);
    return "failed";
  }
  return "OK";
}

/*
Future listFiles(NextcloudClient client) async {
  final files = await client.webdav.ls('/');
  for (final file in files) {
    print(file.path);
  }
}
*/
