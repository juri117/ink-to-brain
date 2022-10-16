import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Word {
  final int id;
  final DateTime insertTs;
  final Uint8List questionPix;
  final String questionTxt;
  final Uint8List answerPix;
  final String answerTxt;
  int correctCount;
  DateTime? lastAskedTs;

  Word(
      {required this.id,
      required this.insertTs,
      required this.questionPix,
      required this.questionTxt,
      required this.answerPix,
      required this.answerTxt,
      required this.correctCount,
      this.lastAskedTs});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'insertTs': insertTs.toString(),
      'questionPix': questionPix,
      'questionTxt': questionTxt,
      'answerPix': answerPix,
      'answerTxt': answerTxt,
      'correctCount': correctCount,
      'lastAskedTs': lastAskedTs?.toString()
    };
  }

  String getInsertDateStr() {
    return DateFormat('dd.MM.yyyy').format(insertTs);
  }

  String getLastAskedDateStr() {
    if (lastAskedTs == null) return "never";
    return DateFormat('dd.MM.yyyy').format(lastAskedTs!);
  }

  Color getScoreColor(BuildContext context) {
    return correctCount < 0
        ? Theme.of(context).errorColor
        : Theme.of(context).colorScheme.primary;
  }
}
