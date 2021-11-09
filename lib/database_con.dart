import 'package:flutter/material.dart';
import 'package:ink2brain/models/word.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io' as io;

class DatabaseCon {
  static final DatabaseCon _dbCon = DatabaseCon._internal();

  factory DatabaseCon() {
    return _dbCon;
  }

  DatabaseCon._internal();

  Database? con;

  Future<void> _requestWritePermission() async {
    if (io.Platform.isAndroid || io.Platform.isIOS) {
      var status = await Permission.storage.status;
      if (status.isDenied) {
        // You can request multiple permissions at once.
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
        ].request();
        // print(statuses[Permission.storage]);
      }
    }
  }

  Future<void> openCon() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _requestWritePermission();

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
              return db.execute("CREATE TABLE words (" +
                      "id	INTEGER UNIQUE NOT NULL,	" +
                      "insertTs DATETIME DEFAULT (CURRENT_TIMESTAMP), " +
                      "foreignPix	BLOB, " +
                      "foreignWord	TEXT, " +
                      "motherTounghePix	BLOB, " +
                      "motherToungheWord	TEXT, " +
                      "correctCount	NUMERIC, " +
                      "lastAskedTs DATETIME, " +
                      "PRIMARY KEY(id AUTOINCREMENT));"
                  //'CREATE TABLE words(id INTEGER PRIMARY KEY, foreignPix BLOB, foreignWord TEXT, motherTounghePix BLOB, motherToungheWord TEXT, correctCount INTEGER)',
                  );
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
                  return db.execute(
                    'CREATE TABLE words(id INTEGER PRIMARY KEY, foreignPix BLOB, foreignWord TEXT, motherTounghePix BLOB, motherToungheWord TEXT, correctCount INTEGER)',
                  );
                },
                version: 1,
              ));
    }

    /*
    io.Directory directory = io.Directory.current;
    if (io.Platform.isAndroid) {
      directory = await getApplicationDocumentsDirectory();
    }

    io.Directory(path.join(directory.path, 'db'))
        .create(recursive: true)
        .then((io.Directory directory) {
      print('Path of New Dir: ' + directory.path);
    });

    //io.Directory(path.join(directory.path, "db")).create();

    String dbPath = path.join(directory.path, 'db', 'words.db');

    sqfliteFfiInit();

    var databaseFactory = databaseFactoryFfi;
    //con = await databaseFactory.openDatabase(inMemoryDatabasePath);

    con = await databaseFactory.openDatabase(dbPath,
        options: OpenDatabaseOptions(
          onCreate: (db, version) {
            return db.execute(
              'CREATE TABLE words(id INTEGER PRIMARY KEY, foreignPix BLOB, foreignWord TEXT, motherTounghePix BLOB, motherToungheWord TEXT, correctCount INTEGER)',
            );
          },
          version: 1,
        ));
        */
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
        foreignPix: maps[i]['foreignPix'],
        foreignWord: maps[i]['foreignWord'],
        motherTounghePix: maps[i]['motherTounghePix'],
        motherToungheWord: maps[i]['motherToungheWord'],
        correctCount: maps[i]['correctCount'],
        lastAskedTs: lastAskedTs,
      );
    });
  }

  Future<void> updateWord(Word word) async {
    await con?.update(
      'words',
      word.toMap(),
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  Future<void> incrementCorrect(Word word) async {
    word.correctCount++;
    word.lastAskedTs = DateTime.now();
    updateWord(word);
  }

  Future<void> resetCorrect(Word word) async {
    word.correctCount = 0;
    word.lastAskedTs = DateTime.now();
    updateWord(word);
  }
}
