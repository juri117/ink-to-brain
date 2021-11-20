import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ink2brain/database_con.dart';
import 'package:ink2brain/models/word.dart';
import 'package:ink2brain/widgets/write_widget.dart';
import 'package:ink2brain/widgets/painter.dart';

enum WorkoutState { ask, answer, done }

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key}) : super(key: key);

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
        where:
            "correctCount < 3 OR (correctCount == 3 AND lastAskedTs >= date('now', '-3 day'))");
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

    setState(() {
      _state = WorkoutState.ask;
      _controller = _newController();
      index++;
      if (words.length > index) {
        currentWord = words[index];
      } else {
        print("reload words");
        _loadWords();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Workout"),
        ),
        body: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                flex: 2,
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(
                                color: Colors.transparent, width: 1.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(3))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                flex: 3,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorLight,
                                    //border: Border.all(
                                    //    color: Theme.of(context).primaryColor,
                                    //    width: 1.5),
                                    //borderRadius: const BorderRadius.all(Radius.circular(3))
                                  ),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: AspectRatio(
                                          aspectRatio: 3,
                                          child: currentWord.id <= 0
                                              ? const Center(
                                                  child: Text("loading..."))
                                              : Image.memory(
                                                  currentWord.questionPix))),
                                )),
                            const SizedBox(width: 10),
                            Icon(Icons.compare_arrows_outlined,
                                size: 40,
                                color: Theme.of(context).primaryColor),
                            const SizedBox(width: 10),
                            Expanded(
                                flex: 3,
                                child: Container(
                                    decoration: BoxDecoration(
                                      //color: const Color(0xFFE4FFE6),
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      //border: Border.all(
                                      //    color: Theme.of(context).primaryColor,
                                      //    width: 1.5),
                                      //borderRadius: const BorderRadius.all(Radius.circular(3))
                                    ),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                            aspectRatio: 3,
                                            child: currentWord.id <= 0 ||
                                                    _state == WorkoutState.ask
                                                ? Center(
                                                    child: Icon(
                                                        Icons.visibility_off,
                                                        size: 40,
                                                        color: Theme.of(context)
                                                            .primaryColor))
                                                : Image.memory(
                                                    currentWord.answerPix))))),
                            //const SizedBox(width: 10),
                            Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(children: [
                                  Text("score: ${currentWord.correctCount}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: currentWord.correctCount < 0
                                              ? Theme.of(context).errorColor
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary)),
                                  const SizedBox(
                                    height: 10,
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
                        )))),
            Expanded(
              flex: 4,
              child: WriteWidget(
                "dummy",
                _controller,
                pen: true,
              ),
            ),
            Expanded(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: generateButtonBar(_state))),
          ],
        ));

    // return out;
  }

  Widget generateButtonBar(WorkoutState state) {
    switch (state) {
      case WorkoutState.ask:
        return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          SizedBox(
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
                    _state = WorkoutState.answer;
                  });
                },
              ))
        ]);
      case WorkoutState.answer:
        return Row(
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
                    _save(currentWord, true);
                  },
                )),
          ],
        );
      default:
        return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          )
        ]);
    }
  }
}
