import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ink2brain/utils/file_utils.dart';
import 'package:nextcloud/nextcloud.dart';

Future<NextCloudClient?> ncGetClient() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // final SharedPreferences prefs = await _prefs;
  final String host = prefs.getString('nextcloud_host') ?? "";
  final String user = prefs.getString('nextcloud_user') ?? "";
  final String pw = prefs.getString('nextcloud_pw') ?? "";

  if (host == "" || user == "" || pw == "") {
    return null;
  }

  return NextCloudClient.withCredentials(
    Uri(host: host),
    user,
    pw,
  );
}

Future<String> ncUploadFile() async {
  try {
    final String? dbPath = await getDbPath();
    if (dbPath == null) {
      print("could not find db file path");
      return "could not find db file path";
    }

    final client = await ncGetClient();
    if (client == null) {
      print("no nextcloude host defined");
      return "no nextcloude host defined";
    }

    String date = DateFormat("yyyy-MM-dd_HH-mm-ss").format(DateTime.now());
    await client.webDav.copy('/words.db', '/words_old_$date.db');
    await client.webDav.upload(File(dbPath).readAsBytesSync(), '/words.db');
  } on RequestException catch (e, stacktrace) {
    print(e.statusCode);
    print(e.body);
    print(stacktrace);
    return "failed";
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
      print("no nextcloude host defined");
      return "no nextcloude host defined";
    }

    File(dbPath).writeAsBytesSync(await client.webDav.download('/words.db'));
  } on RequestException catch (e, stacktrace) {
    print(e.statusCode);
    print(e.body);
    print(stacktrace);
    return "failed";
  }
  return "OK";
}

Future listFiles(NextCloudClient client) async {
  final files = await client.webDav.ls('/');
  for (final file in files) {
    print(file.path);
  }
}