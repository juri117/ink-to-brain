class Stat {
  final int totalCount;
  final int activeCount;
  final int learnedCount;
  final int todayCount;
  final int leftForToday;

  Stat(
      {required this.totalCount,
      required this.activeCount,
      required this.learnedCount,
      required this.todayCount,
      required this.leftForToday});

  Map<String, dynamic> toMap() {
    return {
      'totalCount': totalCount,
      'activeCount': activeCount,
      'learnedCount': learnedCount,
      'todayCount': todayCount,
      'leftForToday': leftForToday
    };
  }
}
