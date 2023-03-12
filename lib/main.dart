import 'dart:io';
import 'package:desktop_window/desktop_window.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'package:flutter/material.dart';
import 'package:ink2brain/database_con.dart';
import 'package:ink2brain/list.dart';
import 'package:ink2brain/models/stat.dart';
import 'package:ink2brain/models/word.dart';
import 'package:ink2brain/new_words.dart';
import 'package:ink2brain/settings.dart';
import 'package:ink2brain/theme.dart';
import 'package:ink2brain/utils/nextcloud.dart';
import 'package:ink2brain/widgets/word_display.dart';
import 'package:ink2brain/workout.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String versionName = "0.00.005";

void main() async {
  await DatabaseCon().openCon();
  // await ncUploadFile();
  if (Platform.isWindows) {
    DesktopWindow.setFullScreen(true);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ink to brain",
      home: const MainFrame(),
      theme: FlexThemeData.light(
        colors: myFlexScheme.light,
        //appBarElevation: 0.5,
      ),
      darkTheme: FlexThemeData.dark(
        colors: myFlexScheme.dark,
      ),
      themeMode: themeMode,
    );
  }
}

class MainFrame extends StatefulWidget {
  const MainFrame({Key? key}) : super(key: key);

  @override
  MainFrameState createState() => MainFrameState();
}

class MainFrameState extends State<MainFrame> {
  // Widget? content;

  final ScrollController _scrollController = ScrollController();

  Stat stat = Stat(
      totalCount: -1,
      activeCount: -1,
      learnedCount: -1,
      todayCount: -1,
      leftForToday: -1);
  List<Word> badWords = [];

  bool useTextOverImage = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _loadData();
  }

  Future<void> _loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    useTextOverImage = prefs.getBool('use_text_if_exists') ?? false;
  }

  Future<void> _loadData() async {
    Stat newStat = await DatabaseCon().statistic();
    List<Word> newBadWords =
        await DatabaseCon().words(orderBy: "correctCount", limit: 4);
    setState(() {
      stat = newStat;
      badWords = newBadWords;
    });
  }

  Future<void> _startWorkout() async {
    // bool legacyVal = false;
    final ScrollController dialogScrollController = ScrollController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('start workout...'),
            content: Scrollbar(
                controller: dialogScrollController,
                thumbVisibility:
                    Platform.isWindows || Platform.isLinux || Platform.isMacOS,
                child: SingleChildScrollView(
                    controller: dialogScrollController,
                    child: SizedBox(
                        //height: 200,
                        child: Column(children: [
                      Container(
                          width: 220,
                          padding: const EdgeInsets.all(5),
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.baby_changing_station),
                            label: const Text('5 questions'),
                            onPressed: () {
                              Navigator.pop(context);
                              _navigateToWorkout(5, false);
                            },
                          )),
                      Container(
                          width: 220,
                          padding: const EdgeInsets.all(5),
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.school),
                            label: const Text('10 questions'),
                            onPressed: () {
                              Navigator.pop(context);
                              _navigateToWorkout(10, false);
                            },
                          )),
                      Container(
                          width: 220,
                          padding: const EdgeInsets.all(5),
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.fitness_center),
                            label: const Text('15 questions'),
                            onPressed: () {
                              Navigator.pop(context);
                              _navigateToWorkout(15, false);
                            },
                          )),
                      Container(
                          width: 220,
                          padding: const EdgeInsets.all(5),
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.airplanemode_on),
                            label: const Text('all questions'),
                            onPressed: () {
                              Navigator.pop(context);
                              _navigateToWorkout(99999, false);
                            },
                          )),
                      Container(
                          width: 220,
                          padding: const EdgeInsets.all(5),
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.bolt_rounded),
                            label: const Text('all questions (legacy)'),
                            onPressed: () {
                              Navigator.pop(context);
                              _navigateToWorkout(99999, true);
                            },
                          )),
                    ])))),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('cancel'),
              )
            ],
          );
        });
  }

  Future<void> _navigateToWorkout(int limit, bool legacy) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WorkoutPage(
                limit: limit,
                legacy: legacy,
              )),
    ).then((value) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> badWordWidgetList = [];
    for (final w in badWords) {
      badWordWidgetList.add(Container(
          padding:
              const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
          width: MediaQuery.of(context).orientation == Orientation.landscape
              ? MediaQuery.of(context).size.width * 0.5
              : MediaQuery.of(context).size.width,
          child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  border: Border.all(color: Colors.transparent, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(3))),
              child: Row(
                children: [
                  Text("${w.correctCount}",
                      style: TextStyle(color: w.getScoreColor(context))),
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 3,
                      child: WordDisplay(
                          w.questionPix, w.questionTxt, useTextOverImage)),
                  const SizedBox(width: 10),
                  Icon(Icons.compare_arrows_outlined,
                      size: 40, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 3,
                      child: WordDisplay(
                          w.answerPix, w.answerTxt, useTextOverImage))
                ],
              ))));
    }

    return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(35.0), // here the desired height
            child: AppBar(
              title:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("ink to brain"),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "v: $versionName",
                  style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.5)),
                )
              ]),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  tooltip: 'settings',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Settings()),
                    ).then((value) => _loadData());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.sync),
                  tooltip: 'sync.',
                  onPressed: () {
                    showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return const SyncDialog();
                        }).then((value) => _loadData());
                  },
                ),
              ],
            )),
        body: Scrollbar(
          controller: _scrollController,
          thumbVisibility:
              Platform.isWindows || Platform.isLinux || Platform.isMacOS,
          child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(children: [
                Column(
                    //padding: const EdgeInsets.only(
                    //    top: 10.0, bottom: 10, left: 50, right: 50),
                    children: [
                      Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              border: Border.all(
                                  color: Colors.transparent, width: 1.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(3))),
                          child: Column(
                            children: [
                              //Text(
                              //  "Questions:",
                              //  style: TextStyle(fontWeight: FontWeight.bold),
                              //),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(children: [
                                    const Text("total"),
                                    Text("${stat.totalCount}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ]),
                                  Column(children: [
                                    const Text("mastered"),
                                    Text("${stat.learnedCount}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ]),
                                  Column(children: [
                                    const Text("new"),
                                    Text("${stat.activeCount}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ]),
                                  Column(children: [
                                    const Text("practiced today"),
                                    Text("${stat.todayCount}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ]),
                                  Column(children: [
                                    const Text("left for today"),
                                    Text("${stat.leftForToday}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ]),
                                ],
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.fitness_center),
                              label: Container(
                                  width: 150,
                                  padding: const EdgeInsets.all(20),
                                  child: const Text('start workout')),
                              onPressed: () {
                                _startWorkout();
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.list),
                              label: Container(
                                  padding: const EdgeInsets.all(20),
                                  width: 150,
                                  child: const Text('all questions')),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ListPage()),
                                ).then((value) => _loadData());
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.library_add_outlined),
                              label: Container(
                                  width: 150,
                                  padding: const EdgeInsets.all(20),
                                  child: const Text('add questions')),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NewWordPage()),
                                ).then((value) => _loadData());
                              },
                            )
                          ])
                    ]),
                Wrap(
                  children: badWordWidgetList,
                )
              ])),
        ));
  }
}

class SyncDialog extends StatefulWidget {
  const SyncDialog({Key? key}) : super(key: key);

  @override
  SyncDialogStat createState() => SyncDialogStat();
}

class SyncDialogStat extends State<SyncDialog> {
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _uploadDb() async {
    setState(() {
      errorMessage = "loading...";
    });
    await DatabaseCon().closeCon();
    String res = await ncUploadFile();
    setState(() {
      errorMessage = "upload: $res";
    });
    await DatabaseCon().openCon();
  }

  Future<void> _downloadDb() async {
    setState(() {
      errorMessage = "loading...";
    });
    await DatabaseCon().closeCon();
    String res = await ncDownloadFile();
    setState(() {
      errorMessage = "download: $res";
    });
    await DatabaseCon().openCon();
  }

  @override
  Widget build(BuildContext context) {
    Widget doneButton = OutlinedButton(
        child: const Text("done"),
        onPressed: () {
          Navigator.pop(context);
        });
    return AlertDialog(
        actions: [doneButton],
        title: Row(children: const [
          Icon(Icons.sync),
          SizedBox(
            width: 10,
          ),
          Text("sync. database with nextcloud", style: TextStyle(fontSize: 14))
        ]),
        content: SizedBox(
            height: (MediaQuery.of(context).size.height),
            width: (MediaQuery.of(context).size.width),
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Wrap(children: <Widget>[
                  OutlinedButton.icon(
                    icon: const Icon(Icons.download),
                    label: Container(
                        //width: 150,
                        padding: const EdgeInsets.all(5),
                        child: const Text('download, overwrite db')),
                    onPressed: () {
                      _downloadDb();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.upload),
                    label: Container(
                        //width: 150,
                        padding: const EdgeInsets.all(5),
                        child: const Text('upload local db')),
                    onPressed: () {
                      _uploadDb();
                    },
                  ),
                ]),
                const SizedBox(
                  height: 10,
                ),
                Text(errorMessage,
                    style: TextStyle(
                        color: errorMessage.contains("OK") ||
                                errorMessage.contains("loading...")
                            ? Colors.black
                            : Colors.red))
              ],
            ))));
  }
}
