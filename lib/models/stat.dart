import 'dart:typed_data';
import 'package:intl/intl.dart';

class Stat {
  final int totalCount;
  final int activeCount;
  final int learnedCount;
  final int todayCount;

  Stat(
      {required this.totalCount,
      required this.activeCount,
      required this.learnedCount,
      required this.todayCount});

  Map<String, dynamic> toMap() {
    return {
      'totalCount': totalCount,
      'activeCount': activeCount,
      'learnedCount': learnedCount,
      'todayCount': todayCount
    };
  }
}
