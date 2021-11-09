import 'dart:typed_data';
import 'package:intl/intl.dart';

class Word {
  final int id;
  final DateTime insertTs;
  final Uint8List foreignPix;
  final String foreignWord;
  final Uint8List motherTounghePix;
  final String motherToungheWord;
  int correctCount;
  DateTime? lastAskedTs;

  Word(
      {required this.id,
      required this.insertTs,
      required this.foreignPix,
      required this.foreignWord,
      required this.motherTounghePix,
      required this.motherToungheWord,
      required this.correctCount,
      this.lastAskedTs});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'insertTs': insertTs.toString(),
      'foreignPix': foreignPix,
      'foreignWord': foreignWord,
      'motherTounghePix': motherTounghePix,
      'motherToungheWord': motherToungheWord,
      'correctCount': correctCount,
      'lastAskedTs': lastAskedTs?.toString()
    };
  }

  String getInsertDateStr() {
    return DateFormat('dd.MM.yyyy').format(insertTs);
  }

  String getlastAskedDateStr() {
    if (lastAskedTs == null) return "never";
    return DateFormat('dd.MM.yyyy').format(lastAskedTs!);
  }
}
