import 'dart:typed_data';

class Word {
  final int id;
  final Uint8List foreignPix;
  final String foreignWord;
  final Uint8List motherTounghePix;
  final String motherToungheWord;
  int correctCount;

  Word(
      {required this.id,
      required this.foreignPix,
      required this.foreignWord,
      required this.motherTounghePix,
      required this.motherToungheWord,
      required this.correctCount});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foreignPix': foreignPix,
      'foreignWord': foreignWord,
      'motherTounghePix': motherTounghePix,
      'motherToungheWord': motherToungheWord,
      'correctCount': correctCount
    };
  }
}
