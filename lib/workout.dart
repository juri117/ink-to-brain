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
      insertTs: DateTime.fromMicrosecondsSinceEpoch(0),
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
    List<Word> newWords = await DatabaseCon().words(where: "correctCount < 3");
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
    /*
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
    */

    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            flex: 2,
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF7FF),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 1.5),
                        //borderRadius: const BorderRadius.all(Radius.circular(3))
                      ),
                      child: AspectRatio(
                          aspectRatio: 3,
                          child: currentWord.id <= 0
                              ? const Center(child: Text("loading..."))
                              : Image.memory(currentWord.motherTounghePix)),
                    ),
                    Icon(Icons.compare_arrows_outlined,
                        size: 40, color: Theme.of(context).primaryColor),
                    Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE4FFE6),
                          border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.5),
                          //borderRadius: const BorderRadius.all(Radius.circular(3))
                        ),
                        child: AspectRatio(
                            aspectRatio: 3,
                            child: currentWord.id <= 0 || !_showSolution
                                ? const Center(child: Text("???"))
                                : Image.memory(currentWord.foreignPix)))
                  ],
                ))),
        Expanded(
          flex: 4,
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AspectRatio(
                    aspectRatio: 3, //3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 1.5),
                        //borderRadius: const BorderRadius.all(Radius.circular(3))
                      ),
                      child: Stack(alignment: Alignment.topRight, children: [
                        Painter(_controller, usePen: true),
                        Positioned(
                            //alignment: Alignment.topRight,
                            right: 10,
                            // height: 100,
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(children: [
                                  IconButton(
                                      icon: const Icon(Icons.undo),
                                      tooltip: 'Undo',
                                      onPressed: _controller.undo),
                                  IconButton(
                                      icon: const Icon(Icons.delete),
                                      tooltip: 'Clear',
                                      onPressed: _controller.clear)
                                ])))
                      ]),
                    )),
              )),
          /*
          child: Align(
              alignment: Alignment.bottomCenter,
              //height: double.infinity,
              //width: double.infinity,
              //color: Colors.grey,
              //alignment: Alignment.topCenter,
              child: WriteWidget("your answer...", _controller, pen: true)),
              */
        ),
        Expanded(
          flex: 1,
          child: _showSolution
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        width: 200.0,
                        height: 100.0,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.sentiment_satisfied),
                          label: const Text('wrong :('),
                          style: OutlinedButton.styleFrom(
                              primary: Colors.red,
                              backgroundColor: const Color(0xFFFFE4E4)),
                          onPressed: () {
                            _save(currentWord, false);
                          },
                        )),
                    SizedBox(
                        width: 200.0,
                        height: 100.0,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.emoji_emotions_outlined),
                          label: const Text('correct'),
                          style: OutlinedButton.styleFrom(
                              primary: Colors.green,
                              backgroundColor: const Color(0xFFE4FFE6)),
                          onPressed: () {
                            _save(currentWord, false);
                          },
                        )),
                  ],
                )
              : SizedBox(
                  width: 200.0,
                  height: 100.0,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.help_outline),
                    label: const Text('solution'),
                    //style: OutlinedButton.styleFrom(
                    //primary: Colors.green,
                    //backgroundColor: const Color(0xFFE4FFE6)),
                    onPressed: () {
                      setState(() {
                        _showSolution = true;
                      });
                    },
                  )),
        ),
      ],
    );

    // return out;
  }
}
