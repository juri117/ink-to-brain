import 'package:flutter/material.dart';
import 'package:ink2brain/models/word.dart';
import 'package:ink2brain/utils/file_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io' as io;
import 'dart:math';

class DatabaseCon {
  static final DatabaseCon _dbCon = DatabaseCon._internal();

  final String dbCreateQue = ("CREATE TABLE words (" +
      "id	INTEGER UNIQUE NOT NULL,	" +
      "insertTs DATETIME DEFAULT (CURRENT_TIMESTAMP), " +
      "questionPix	BLOB, " +
      "questionTxt	TEXT, " +
      "answerPix	BLOB, " +
      "answerTxt	TEXT, " +
      "correctCount	NUMERIC, " +
      "lastAskedTs DATETIME, " +
      "PRIMARY KEY(id AUTOINCREMENT));");

  factory DatabaseCon() {
    return _dbCon;
  }

  DatabaseCon._internal();

  Database? con;

  Future<void> openCon() async {
    WidgetsFlutterBinding.ensureInitialized();

    await requestWritePermission();

    if (io.Platform.isAndroid) {
      final io.Directory? dir = await getExternalStorageDirectory();
      if (dir == null) {
        print("storage could not be accessed");
        return;
      }
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      con = await databaseFactory.openDatabase(path.join(dir.path, 'words.db'),
          options: OpenDatabaseOptions(
            onCreate: (db, version) {
              return db.execute(dbCreateQue);
            },
            version: 1,
          ));
    }
    if (io.Platform.isWindows) {
      final dir = io.Directory.current;
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      sqfliteFfiInit();
      // var databaseFactory = databaseFactoryFfi;
      con =
          await databaseFactoryFfi.openDatabase(path.join(dir.path, 'words.db'),
              options: OpenDatabaseOptions(
                onCreate: (db, version) {
                  return db.execute(dbCreateQue);
                },
                version: 1,
              ));
    }
  }

  Future<void> insertWord(Word word) async {
    Map<String, dynamic> map = word.toMap();
    map.remove('id');
    map.remove('insertTs');
    map.remove('lastAskedTs');
    await con?.insert(
      'words',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Word>> words({String? where}) async {
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await con?.query('words', where: where) ?? [];

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      DateTime? lastAskedTs;
      if (maps[i]['lastAskedTs'] != null) {
        lastAskedTs = DateTime.parse(maps[i]['lastAskedTs']);
      }
      return Word(
        id: maps[i]['id'],
        insertTs: DateTime.parse(maps[i]['insertTs']),
        questionPix: maps[i]['questionPix'],
        questionTxt: maps[i]['questionTxt'],
        answerPix: maps[i]['answerPix'],
        answerTxt: maps[i]['answerTxt'],
        correctCount: maps[i]['correctCount'],
        lastAskedTs: lastAskedTs,
      );
    });
  }

  Future<void> updateWord(Word word) async {
    Map<String, dynamic> map = word.toMap();
    map.remove("questionPix");
    map.remove("answerPix");
    await con?.update(
      'words',
      map,
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }
}
