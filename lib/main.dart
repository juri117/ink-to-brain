import 'dart:io';
import 'package:desktop_window/desktop_window.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:package_info_plus/package_info_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ink2brain/database_con.dart';
import 'package:ink2brain/list.dart';
import 'package:ink2brain/models/stat.dart';
import 'package:ink2brain/models/word.dart';
import 'package:ink2brain/new_words.dart';
import 'package:ink2brain/noti.dart';
import 'package:ink2brain/settings.dart';
import 'package:ink2brain/theme.dart';
import 'package:ink2brain/widgets/word_display.dart';
import 'package:ink2brain/dialog/sync_dialog.dart';
import 'package:ink2brain/dialog/start_workout_dialog.dart';

import 'package:shared_preferences/shared_preferences.dart';

String versionName = "?.?.?";

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // prevent being send to lockscreen on startup
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );
  }

  // read version
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  versionName = packageInfo.version;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  if (flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>() !=
      null) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
  }

  await DatabaseCon().openCon();
  // await ncUploadFile();
  if (Platform.isWindows) {
    DesktopWindow.setFullScreen(true);
  }

  //if (Platform.isAndroid) {
  //  scheduleDailyTenAMNotification();
  //}

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
  Stat statRev = Stat(
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);
    _loadPrefs();
    _loadData();
    tz.initializeTimeZones();
    if (Platform.isAndroid) {
      Noti.initialize(flutterLocalNotificationsPlugin);
      Noti.zonedScheduleNotification(fln: flutterLocalNotificationsPlugin);
    }
  }

  Future<void> _loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    useTextOverImage = prefs.getBool('use_text_if_exists') ?? false;
  }

  Future<void> _loadData() async {
    Stat newStat = await DatabaseCon().statistic();
    Stat newStatRev = await DatabaseCon().statistic(reverse: true);
    List<Word> newBadWords =
        await DatabaseCon().words(orderBy: "correctCount", limit: 4);
    setState(() {
      stat = newStat;
      statRev = newStatRev;
      badWords = newBadWords;
    });
  }

  Future<void> _startWorkout() async {
    // bool legacyVal = false;
    if (Platform.isAndroid) {
      Noti.zonedScheduleNotification(fln: flutterLocalNotificationsPlugin);
    }

    showDialog(
        context: context,
        builder: (context) {
          return StartWorkoutDialog(_loadData);
        }).then((value) => _loadData());
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

    List<Widget> buttons = [
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
            MaterialPageRoute(builder: (context) => const ListPage()),
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
            MaterialPageRoute(builder: (context) => const NewWordPage()),
          ).then((value) => _loadData());
        },
      ),
    ];

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
                          .withValues(alpha: 0.5)),
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
        body: OrientationBuilder(builder: (context, orientation) {
          return Scrollbar(
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
                                              fontWeight: FontWeight.bold)),
                                      const Text("")
                                    ]),
                                    Column(children: [
                                      const Text("mastered"),
                                      Text("${stat.learnedCount}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text("rev: ${statRev.learnedCount}")
                                    ]),
                                    Column(children: [
                                      const Text("new"),
                                      Text("${stat.activeCount}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text("rev: ${statRev.activeCount}")
                                    ]),
                                    Column(children: [
                                      const Text("practiced today"),
                                      Text("${stat.todayCount}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text("rev: ${statRev.todayCount}")
                                    ]),
                                    Column(children: [
                                      const Text("left for today"),
                                      Text("${stat.leftForToday}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text("rev: ${statRev.leftForToday}")
                                    ]),
                                  ],
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        (orientation == Orientation.landscape)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: buttons)
                            : Column(children: buttons)
                      ]),
                  Wrap(
                    children: badWordWidgetList,
                  )
                ])),
          );
        }));
  }
}
