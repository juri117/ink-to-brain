import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class Word {
  final int id;
  final DateTime insertTs;
  final Uint8List questionPix;
  final String questionTxt;
  final Uint8List answerPix;
  final String answerTxt;
  int correctCount;
  int correctCountRev;
  DateTime? lastAskedTs;
  DateTime? lastAskedRevTs;
  bool isReverse;

  Word(
      {required this.id,
      required this.insertTs,
      required this.questionPix,
      required this.questionTxt,
      required this.answerPix,
      required this.answerTxt,
      required this.correctCount,
      required this.correctCountRev,
      this.lastAskedTs,
      this.lastAskedRevTs,
      this.isReverse = false});

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
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;
  }

  void updateCorrect(bool suc) {
    if (isReverse) {
      if (suc) {
        correctCountRev = max(1, correctCountRev + 1);
      } else {
        correctCountRev = min(3, correctCountRev - 1);
      }
      lastAskedRevTs = DateTime.now();
    } else {
      if (suc) {
        correctCount = max(1, correctCount + 1);
      } else {
        correctCount = min(3, correctCount - 1);
      }
      lastAskedTs = DateTime.now();
    }
  }

  void skip() {
    if (isReverse) {
      if (correctCountRev > 2) {
        correctCountRev = max(0, correctCountRev - 1);
      }
      lastAskedRevTs = DateTime.now();
    } else {
      if (correctCount > 2) {
        correctCount = max(0, correctCount - 1);
      }
      lastAskedTs = DateTime.now();
    }
  }
}
