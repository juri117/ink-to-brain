import 'package:flutter/material.dart';
import 'package:ink2brain/models/stat.dart';
import 'package:ink2brain/models/word.dart';
import 'package:ink2brain/utils/file_utils.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:typed_data';

class DatabaseCon {
  static final DatabaseCon _dbCon = DatabaseCon._internal();

  final String dbCreateQue = ("CREATE TABLE words ("
      "id	INTEGER UNIQUE NOT NULL,	"
      "insertTs DATETIME DEFAULT (CURRENT_TIMESTAMP), "
      "questionPix	BLOB, "
      "questionTxt	TEXT, "
      "answerPix	BLOB, "
      "answerTxt	TEXT, "
      "correctCount	NUMERIC NOT NULL, "
      "correctCountRev	NUMERIC NOT NULL, "
      "lastAskedTs DATETIME, "
      "lastAskedRevTs DATETIME, "
      "PRIMARY KEY(id AUTOINCREMENT));");

  factory DatabaseCon() {
    return _dbCon;
  }

  DatabaseCon._internal();

  Database? con;

  Future<void> openCon() async {
    WidgetsFlutterBinding.ensureInitialized();

    final String? dbPath = await getDbPath();
    if (dbPath == null) {
      //print("could not find db file path");
      return;
    }

    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;

    con = await databaseFactory.openDatabase(dbPath,
        options: OpenDatabaseOptions(
          onCreate: (db, version) {
            return db.execute(dbCreateQue);
          },
          version: 1,
        ));
  }

  Future<void> closeCon() async {
    con?.close();
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

  Future<List<Word>> words(
      {String? where,
      String? orderBy,
      int? limit,
      bool reverse = false}) async {
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await con?.query('words',
            where: where, orderBy: orderBy, limit: limit) ??
        [];

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      DateTime? lastAskedTs;
      if (maps[i]['lastAskedTs'] != null) {
        lastAskedTs = DateTime.parse(maps[i]['lastAskedTs']);
      }
      DateTime? lastAskedRevTs;
      if (maps[i]['lastAskedRevTs'] != null) {
        lastAskedRevTs = DateTime.parse(maps[i]['lastAskedRevTs']);
      }
      return Word(
          id: maps[i]['id'],
          insertTs: DateTime.parse(maps[i]['insertTs']),
          questionPix: maps[i]['questionPix'] ?? Uint8List(0),
          questionTxt: maps[i]['questionTxt'],
          answerPix: maps[i]['answerPix'] ?? Uint8List(0),
          answerTxt: maps[i]['answerTxt'],
          correctCount: maps[i]['correctCount'] ?? 0,
          correctCountRev: maps[i]['correctCountRev'] ?? 0,
          lastAskedTs: lastAskedTs,
          lastAskedRevTs: lastAskedRevTs,
          isReverse: reverse);
    });
  }

  Future<Stat> statistic() async {
    final List<Map<String, dynamic>> maps = await con?.rawQuery(
            "SELECT COUNT(1) AS totalCount, "
            "COUNT(CASE WHEN correctCount < 4 THEN 1 END) AS activeCount, "
            "COUNT(CASE WHEN correctCount >= 4 THEN 1 END) AS learnedCount, "
            "COUNT(CASE WHEN lastAskedTs >= DATE('now', 'start of day') THEN 1 END) AS todayCount, "
            "COUNT(CASE WHEN (correctCount < 0 "
            "OR (correctCount == 1 AND lastAskedTs <= date('now', '-12 hours')) "
            "OR (correctCount == 2 AND lastAskedTs <= date('now', '-2 days')) "
            "OR (correctCount == 3 AND lastAskedTs <= date('now', '-4 days')) "
            "OR (correctCount == 4 AND lastAskedTs <= date('now', '-8 days')) "
            "OR (correctCount == 5 AND lastAskedTs <= date('now', '-16 days'))) THEN 1 END) AS leftForToday "
            "FROM words;") ??
        [];
    if (maps.isNotEmpty) {
      return Stat(
        totalCount: maps[0]['totalCount'],
        activeCount: maps[0]['activeCount'],
        learnedCount: maps[0]['learnedCount'],
        todayCount: maps[0]['todayCount'],
        leftForToday: maps[0]['leftForToday'],
      );
    }
    return Stat(
        totalCount: -1,
        activeCount: -1,
        learnedCount: -1,
        todayCount: -1,
        leftForToday: -1);
  }

  Future<void> updateWord(Word word) async {
    Map<String, dynamic> map = word.toMap();
    //map.remove("questionPix");
    //map.remove("answerPix");
    await con?.update(
      'words',
      map,
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  Future<void> resetWordScore(Word word,
      {correctCount = 0, correctCountRev = 0}) async {
    Map<String, dynamic> map = {
      'correctCount': correctCount,
      'correctCountRev': correctCountRev
    };
    await con?.update(
      'words',
      map,
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  Future<void> deleteWord(int id) async {
    await con?.delete('words', where: 'id = $id');
  }
}
