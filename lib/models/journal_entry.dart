import 'package:intl/intl.dart';

class JournalEntry {
  final int id;
  final DateTime insertTs;
  final DateTime? updateTs;
  final String practiceTxt;

  JournalEntry({
    required this.id,
    required this.insertTs,
    this.updateTs,
    required this.practiceTxt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'insertTs': insertTs.toString(),
      'updateTs': updateTs?.toString(),
      'practiceTxt': practiceTxt,
    };
  }

  String getInsertDateStr() {
    return DateFormat('dd.MM.yyyy HH:mm').format(insertTs);
  }

  String getPreview({int maxLen = 80}) {
    final t = practiceTxt.trim();
    if (t.length <= maxLen) return t;
    return '${t.substring(0, maxLen)}…';
  }
}
