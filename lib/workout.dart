import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter_device_type/flutter_device_type.dart';

import 'package:flutter/material.dart';
import 'package:ink2brain/database_con.dart';
import 'package:ink2brain/models/word.dart';
import 'package:ink2brain/widgets/write_widget.dart';
import 'package:ink2brain/widgets/painter.dart';

enum WorkoutState { ask, answer, done }

class WorkoutPage extends StatefulWidget {
  final int limit;
  final bool persistent;
  const WorkoutPage({this.limit = 9999999, this.persistent = false, Key? key})
      : super(key: key);

  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  PainterController _controller = _newController();
  List<Word> words = [];
  WorkoutState _state = WorkoutState.ask;
  Word currentWord = Word(
      id: -1,
      insertTs: DateTime.fromMicrosecondsSinceEpoch(0),
      questionPix: Uint8List(0),
      questionTxt: "",
      answerPix: Uint8List(0),
      answerTxt: "",
      correctCount: 0);
  int index = 0;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    List<Word> newWords = await DatabaseCon().words(
        where: ("correctCount < 3 "
            "OR (correctCount == 2 AND lastAskedTs <= date('now', '-1 hours')) "
            "OR (correctCount == 3 AND lastAskedTs <= date('now', '-3 days')) "
            "OR (correctCount == 4 AND lastAskedTs <= date('now', '-7 days')) "
            "OR (correctCount == 5 AND lastAskedTs <= date('now', '-14 days'))"),
        orderBy: "RANDOM()",
        limit: widget.limit);
    setState(() {
      newWords.shuffle();
      words = newWords;
      index = 0;
      if (words.length > index) {
        currentWord = words[index];
      } else {
        currentWord = Word(
            id: -1,
            insertTs: DateTime.fromMicrosecondsSinceEpoch(0),
            questionPix: Uint8List(0),
            questionTxt: "",
            answerPix: Uint8List(0),
            answerTxt: "",
            correctCount: 0);
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

  Future<void> _skip() async {
    setState(() {
      _state = WorkoutState.done;
    });

    await Future.delayed(const Duration(seconds: 5), () {});

    words.removeAt(0);
    setState(() {
      _state = WorkoutState.ask;
      _controller = _newController();
      // index++;
      if (words.isNotEmpty) {
        currentWord = words[0];
      } else {
        print("reload words");
        _loadWords();
      }
    });
  }

  Future<void> _save(Word word, bool suc) async {
    if (suc) {
      word.correctCount = max(1, word.correctCount + 1);
    } else {
      word.correctCount = min(-1, word.correctCount - 1);
    }
    word.lastAskedTs = DateTime.now();
    DatabaseCon().updateWord(word);

    setState(() {
      currentWord = word;
      _state = WorkoutState.done;
    });

    await Future.delayed(const Duration(seconds: 2), () {});

    words.removeAt(0);
    if (!suc) {
      words.add(currentWord);
    }

    setState(() {
      _state = WorkoutState.ask;
      _controller = _newController();
      // index++;
      if (words.isNotEmpty) {
        currentWord = words[0];
      } else {
        print("reload words");
        _loadWords();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget questoinCont = Expanded(
        flex: 2,
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(color: Colors.transparent, width: 1.5),
                    borderRadius: const BorderRadius.all(Radius.circular(3))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                          ),
                          child: Align(
                              alignment: Alignment.center,
                              child: AspectRatio(
                                  aspectRatio: 3,
                                  child: currentWord.id <= 0
                                      ? const Center(child: Text("loading..."))
                                      : Image.memory(currentWord.questionPix))),
                        )),
                    const SizedBox(width: 10),
                    Icon(Icons.compare_arrows_outlined,
                        size: 40, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 10),
                    Expanded(
                        flex: 3,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                            ),
                            child: Align(
                                alignment: Alignment.center,
                                child: AspectRatio(
                                    aspectRatio: 3,
                                    child: currentWord.id <= 0 ||
                                            _state == WorkoutState.ask
                                        ? Center(
                                            child: Icon(Icons.visibility_off,
                                                size: 40,
                                                color: Theme.of(context)
                                                    .primaryColor))
                                        : Image.memory(
                                            currentWord.answerPix))))),
                    //const SizedBox(width: 10),
                    Container(
                        padding: const EdgeInsets.all(5),
                        child: Column(children: [
                          Text("${words.length} left"),
                          const Divider(
                            height: 5,
                          ),
                          Text("score: ${currentWord.correctCount}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  // fontSize: 18,
                                  color: currentWord.getScoreColor(context))),
                          const SizedBox(
                            height: 2,
                          ),
                          Wrap(
                            children: List.generate(
                                min(5, currentWord.correctCount.abs()),
                                (index) {
                              return Center(
                                child: Icon(
                                    currentWord.correctCount >= 0
                                        ? Icons.star
                                        : Icons.block_outlined,
                                    color: currentWord.correctCount >= 0
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).errorColor,
                                    size: 18),
                              );
                            }),
                          )
                        ]))
                  ],
                ))));

    List<Widget> mainRow = [
      questoinCont,
      Expanded(
        flex: 4,
        child: WriteWidget(
          _controller,
          pen: true,
        ),
      ),
      Expanded(
          flex: 1,
          child: Padding(
              padding: const EdgeInsets.all(5),
              child: generateButtonBar(_state))),
    ];

    if (Device.get().isPhone &&
        MediaQuery.of(context).orientation == Orientation.landscape &&
        !Platform.isWindows) {
      mainRow = [
        questoinCont,
        Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                WriteWidget(
                  _controller,
                  pen: true,
                ),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: generateButtonBar(_state))
              ],
            )),
      ];
    }

    return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(35.0), // here the desired height
            child: AppBar(
              title: const Text("Workout"),
            )),
        body: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: mainRow,
        ));

    // return out;
  }

  Widget generateButtonBar(WorkoutState state) {
    List<Widget> buttons = [];
    switch (state) {
      case WorkoutState.ask:
        buttons = [
          OutlinedButton.icon(
            icon: const Icon(Icons.skip_next_outlined),
            label: const Text('skip'),
            onPressed: () {
              _skip();
            },
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.help_outline),
            label: const Text('solution'),
            //style: OutlinedButton.styleFrom(
            //primary: Colors.green,
            //backgroundColor: const Color(0xFFE4FFE6)),
            onPressed: () {
              setState(() {
                _state = WorkoutState.answer;
              });
            },
          ),
          const SizedBox(
            width: 5,
          ),
          const SizedBox(
            width: 5,
          )
        ];
        break;
      case WorkoutState.answer:
        buttons = [
          const SizedBox(
            width: 5,
          ),
          const SizedBox(
            width: 5,
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.sentiment_satisfied),
            label: const Text('wrong :('),
            style: OutlinedButton.styleFrom(
                primary: Colors.red, backgroundColor: const Color(0xFFFFE4E4)),
            onPressed: () {
              _save(currentWord, false);
            },
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.emoji_emotions_outlined),
            label: const Text('correct'),
            style: OutlinedButton.styleFrom(
                primary: Colors.green,
                backgroundColor: const Color(0xFFE4FFE6)),
            onPressed: () {
              _save(currentWord, true);
            },
          ),
        ];
        break;
      default:
        buttons = [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          )
        ];
    }
    if (Device.get().isPhone &&
        MediaQuery.of(context).orientation == Orientation.landscape &&
        !Platform.isWindows) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround, children: buttons);
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, children: buttons);
  }
}
