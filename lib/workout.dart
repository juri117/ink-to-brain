import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ink2brain/database_con.dart';
import 'package:ink2brain/models/word.dart';
import 'package:ink2brain/widgets/write_widget.dart';
import 'package:ink2brain/widgets/painter.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  PainterController _controller = _newController();
  List<Word> words = [];
  Word currentWord = Word(
      id: -1,
      foreignPix: Uint8List(0),
      foreignWord: "",
      motherTounghePix: Uint8List(0),
      motherToungheWord: "",
      correctCount: 0);
  int index = 0;
  bool _showSolution = false;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    List<Word> newWords = await DatabaseCon().words();
    setState(() {
      newWords.shuffle();
      words = newWords;
      index = 0;
      if (words.length > index) {
        currentWord = words[index];
      }
    });
  }

  static PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 1.5;
    controller.drawColor = Colors.blue[900]!;
    controller.backgroundColor = Colors.transparent;
    return controller;
  }

  Future<void> _save(Word word, bool suc) async {
    if (suc) {
      DatabaseCon().incrementCorrect(word);
    } else {
      DatabaseCon().resetCorrect(word);
    }

    setState(() {
      _showSolution = false;
      _controller = _newController();
      index++;
      if (words.length > index) {
        currentWord = words[index];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget out = const Text("loading...");
    if (currentWord.id > 0) {
      Widget leftSide = const Text("...");
      if (_showSolution) {
        leftSide = Column(children: [
          Image.memory(currentWord.motherTounghePix),
          Container(
              color: Colors.green[100]!,
              child: Image.memory(currentWord.foreignPix))
        ]);
      } else {
        leftSide =
            Column(children: [Image.memory(currentWord.motherTounghePix)]);
      }
      out = Column(children: [
        Row(
          children: [
            leftSide,
            WriteWidget("hint", _controller, pen: true),
          ],
        ),
        _showSolution
            ? Row(
                children: [
                  ElevatedButton(
                    child: const Text('wrong :('),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      _save(currentWord, false);
                    },
                  ),
                  ElevatedButton(
                    child: const Text('correct :)'),
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    onPressed: () {
                      _save(currentWord, true);
                    },
                  )
                ],
              )
            : ElevatedButton(
                child: const Text('done'),
                onPressed: () {
                  setState(() {
                    _showSolution = true;
                  });
                },
              ),
      ]);
    }
    return out;
  }
}
