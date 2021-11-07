import 'package:flutter/material.dart';
import 'package:ink_test2/database_con.dart';
import 'package:ink_test2/new_words.dart';
import 'package:ink_test2/workout.dart';

//void main() => runApp(MyApp());

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
            Column(children: [
              ElevatedButton(
                child: const Text('new words'),
                onPressed: () {
                  setState(() {
                    content = const NewWordPage();
                  });
                },
              ),
              ElevatedButton(
                child: const Text('workout'),
                onPressed: () {
                  setState(() {
                    content = const WorkoutPage();
                  });
                },
              ),
            ]));
  }
}
