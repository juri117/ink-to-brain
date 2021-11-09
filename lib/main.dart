// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ink2brain/database_con.dart';
import 'package:ink2brain/list.dart';
import 'package:ink2brain/new_words.dart';
import 'package:ink2brain/workout.dart';

void main() async {
  DatabaseCon().openCon();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ink to brain',
      home: MainFrame(),
    );
  }
}

class MainFrame extends StatefulWidget {
  const MainFrame({Key? key}) : super(key: key);

  @override
  _MainFrameState createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  Widget? content;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('ink to brain'), actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Home',
            onPressed: () {
              setState(() {
                content = null;
              });
            },
          ),
        ]),
        body: content ??
            Center(
                child: ListView(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10, left: 50, right: 50),
                    children: [
                  OutlinedButton(
                    child: const Padding(
                        padding: EdgeInsets.all(20), child: Text('new words')),
                    onPressed: () {
                      setState(() {
                        content = const NewWordPage();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                    child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('list of words')),
                    onPressed: () {
                      setState(() {
                        content = const ListPage();
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                    child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('start workout')),
                    onPressed: () {
                      setState(() {
                        content = const WorkoutPage();
                      });
                    },
                  ),
                ])));
  }
}
