import 'package:flutter/material.dart';
import 'package:ink_test2/models/word.dart';
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

  Future<void> openCon() async {
    WidgetsFlutterBinding.ensureInitialized();

    io.Directory directory = io.Directory.current;
    if (io.Platform.isAndroid) {
      directory = await getApplicationDocumentsDirectory();
    }
    io.Directory(path.join(directory.path, "db")).create();

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
  }

  Future<void> insertWord(Word word) async {
    Map<String, dynamic> map = word.toMap();
    map.remove('id');
    await con?.insert(
      'words',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Word>> words() async {
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await con?.query('words') ?? [];

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Word(
          id: maps[i]['id'],
          foreignPix: maps[i]['foreignPix'],
          foreignWord: maps[i]['foreignWord'],
          motherTounghePix: maps[i]['motherTounghePix'],
          motherToungheWord: maps[i]['motherToungheWord'],
          correctCount: maps[i]['correctCount']);
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
    updateWord(word);
  }

  Future<void> resetCorrect(Word word) async {
    word.correctCount = 0;
    updateWord(word);
  }
}
