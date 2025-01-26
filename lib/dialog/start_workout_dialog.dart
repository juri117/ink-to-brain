import 'package:flutter/material.dart';
import 'package:ink2brain/workout.dart';

import 'dart:io';

class StartWorkoutDialog extends StatefulWidget {
  final Function refreshMain;
  const StartWorkoutDialog(this.refreshMain, {Key? key}) : super(key: key);

  @override
  StartWorkoutDialogStat createState() => StartWorkoutDialogStat();
}

class StartWorkoutDialogStat extends State<StartWorkoutDialog> {
  final ScrollController dialogScrollController = ScrollController();

  bool learnReverse = false;
  bool learnLegacy = false;

  final List<LearnOption> learnOptions = [
    const LearnOption("5", 5),
    const LearnOption("10", 10),
    const LearnOption("15", 15),
    const LearnOption("all", 9999)
  ];
  LearnOption? selectedLearnOption;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _navigateToWorkout(int limit, bool reverse, bool legacy) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WorkoutPage(
                limit: limit,
                legacy: legacy,
                reverse: reverse,
              )),
    ).then((value) => widget.refreshMain());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //title: const Text('start workout...'),
      content: SizedBox(
          height: 190, //(MediaQuery.of(context).size.height),
          width: 500,
          child: Scrollbar(
              controller: dialogScrollController,
              thumbVisibility:
                  Platform.isWindows || Platform.isLinux || Platform.isMacOS,
              child: SingleChildScrollView(
                  controller: dialogScrollController,
                  child: Column(children: [
                    Row(children: [
                      SizedBox(
                          width: 140,
                          height: 60,
                          child: SwitchListTile(
                            title: const Text('reverse'),
                            contentPadding: const EdgeInsets.only(right: 8),
                            visualDensity: VisualDensity.compact,
                            value: learnReverse,
                            onChanged: (bool value) {
                              setState(() {
                                learnReverse = value;
                              });
                            },
                            //secondary:
                            //    const Icon(Icons.lightbulb_outline),
                          )),
                      SizedBox(
                          width: 140,
                          height: 60,
                          child: SwitchListTile(
                            title: const Text('legacy'),
                            contentPadding: const EdgeInsets.only(left: 8),
                            visualDensity: VisualDensity.compact,
                            value: learnLegacy,
                            onChanged: (bool value) {
                              setState(() {
                                learnLegacy = value;
                              });
                            },
                            //secondary:
                            //    const Icon(Icons.lightbulb_outline),
                          )),
                    ]),
                    SizedBox(height: 10),
                    GridView.count(
                      childAspectRatio: 2.5,
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      children: List.generate(learnOptions.length, (index) {
                        return SizedBox(
                            width: 140,
                            height: 60,
                            child: OutlinedButton(
                              style: (learnOptions[index] ==
                                      selectedLearnOption)
                                  ? ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.3)))
                                  : null,
                              onPressed: () {
                                setState(() {
                                  selectedLearnOption = learnOptions[index];
                                });
                              },
                              child: Text(
                                learnOptions[index].name,
                                style: TextStyle(fontSize: 16),
                              ),
                            ));
                      }),
                    ),
                  ])))),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('cancel'),
        ),
        TextButton(
          onPressed: selectedLearnOption == null
              ? null
              : () {
                  Navigator.pop(context);
                  _navigateToWorkout(selectedLearnOption?.count ?? 5,
                      learnReverse, learnLegacy);
                },
          child: const Text('GO'),
        )
      ],
    );
  }
}

class LearnOption {
  final String name;
  final int count;
  const LearnOption(this.name, this.count);
}
