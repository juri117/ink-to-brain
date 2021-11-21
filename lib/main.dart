// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ink2brain/database_con.dart';
import 'package:ink2brain/list.dart';
import 'package:ink2brain/models/stat.dart';
import 'package:ink2brain/new_words.dart';
import 'package:ink2brain/settings.dart';
import 'package:ink2brain/theme.dart';
import 'package:ink2brain/utils/nextcloude.dart';
import 'package:ink2brain/workout.dart';

void main() async {
  await DatabaseCon().openCon();
  // await ncUploadFile();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ink to brain', home: MainFrame(), theme: myTheme);
  }
}

class MainFrame extends StatefulWidget {
  const MainFrame({Key? key}) : super(key: key);

  @override
  _MainFrameState createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  // Widget? content;

  Stat stat =
      Stat(totalCount: -1, activeCount: -1, learnedCount: -1, todayCount: -1);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    Stat newStat = await DatabaseCon().statistic();
    setState(() {
      stat = newStat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ink to brain'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'sync.',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                ).then((value) => _loadData());
              },
            ),
            IconButton(
              icon: const Icon(Icons.sync),
              tooltip: 'settings',
              onPressed: () {
                showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return SyncDialog();
                    }).then((value) => _loadData());
              },
            ),
          ],
        ),
        body: //content ??
            Center(
                child: ListView(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10, left: 50, right: 50),
                    children: [
              Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(color: Colors.transparent, width: 1.5),
                      borderRadius: const BorderRadius.all(Radius.circular(3))),
                  child: Column(
                    children: [
                      //Text(
                      //  "Questions:",
                      //  style: TextStyle(fontWeight: FontWeight.bold),
                      //),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(children: [
                            Text("total"),
                            Text("${stat.totalCount}",
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                          Column(children: [
                            Text("mastered"),
                            Text("${stat.learnedCount}",
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                          Column(children: [
                            Text("almost mastered"),
                            Text("${stat.activeCount}",
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                          Column(children: [
                            Text("practiced today"),
                            Text("${stat.todayCount}",
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                        ],
                      )
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              OutlinedButton.icon(
                icon: Icon(Icons.fitness_center),
                label: Container(
                    width: 150,
                    padding: EdgeInsets.all(20),
                    child: Text('start workout')),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WorkoutPage()),
                  ).then((value) => _loadData());
                  //setState(() {
                  //  content = const WorkoutPage();
                  //});
                },
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton.icon(
                icon: Icon(Icons.list),
                label: Container(
                    padding: EdgeInsets.all(20),
                    width: 150,
                    child: Text('list of questions')),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListPage()),
                  ).then((value) => _loadData());
                  /*
                  setState(() {
                    content = const ListPage();
                  });
                  */
                },
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton.icon(
                icon: Icon(Icons.library_add_outlined),
                label: Container(
                    width: 150,
                    padding: EdgeInsets.all(20),
                    child: Text('add questions')),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewWordPage()),
                  ).then((value) => _loadData());
                  /*
                  setState(() {
                    content = const NewWordPage();
                  });
                  */
                },
              ),
            ])));
  }
}

class SyncDialog extends StatefulWidget {
  const SyncDialog();

  @override
  _SyncDialogStat createState() => new _SyncDialogStat();
}

class _SyncDialogStat extends State<SyncDialog> {
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
        child: Text("done"),
        onPressed: () {
          Navigator.pop(context);
        });
    return AlertDialog(
        actions: [doneButton],
        title: Text("sync. database with nextcloude",
            style: TextStyle(fontSize: 14)),
        content: Container(
            height: 260,
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                OutlinedButton.icon(
                  icon: Icon(Icons.upload),
                  label: Container(
                      width: 150,
                      padding: EdgeInsets.all(20),
                      child: Text('upload local db')),
                  onPressed: () {
                    _uploadDb();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                OutlinedButton.icon(
                  icon: Icon(Icons.download),
                  label: Container(
                      width: 150,
                      padding: EdgeInsets.all(20),
                      child: Text('download, overwrite db')),
                  onPressed: () {
                    _downloadDb();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text("$errorMessage",
                    style: TextStyle(
                        color: errorMessage.contains("OK") ||
                                errorMessage.contains("loading...")
                            ? Colors.black
                            : Colors.red))
              ],
            ))));
  }
}
