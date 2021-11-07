import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ink_test2/database_con.dart';
import 'package:ink_test2/models/word.dart';
import 'package:painter/painter.dart';

class NewWordPage extends StatefulWidget {
  const NewWordPage({Key? key}) : super(key: key);

  @override
  _NewWordPageState createState() => _NewWordPageState();
}

class _NewWordPageState extends State<NewWordPage> {
  //bool _finished = false;
  PainterController _controller = _newController();
  PainterController _controllerTrans = _newController();

  @override
  void initState() {
    super.initState();
  }

  static PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 1.5;
    controller.drawColor = Colors.blue[900]!;
    controller.backgroundColor = Colors.transparent;
    return controller;
  }

  Future<void> _save() async {
    Uint8List foreignPix = await _controller.finish().toPNG();
    Uint8List motherTounghePix = await _controllerTrans.finish().toPNG();

    DatabaseCon().insertWord(Word(
        id: -1,
        foreignPix: foreignPix,
        foreignWord: "",
        motherTounghePix: motherTounghePix,
        motherToungheWord: "",
        correctCount: 0));

    setState(() {
      _controller = _newController();
      _controllerTrans = _newController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          _drawInput("word to learn", _controller),
          _drawInput("hint", _controllerTrans),
        ],
      ),
      ElevatedButton(
        child: const Text('save'),
        onPressed: () {
          _save();
        },
      ),
    ]);
  }

  Widget _drawInput(String title, PainterController controller) {
    return Expanded(
        flex: 1,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 1.5),
                borderRadius: const BorderRadius.all(Radius.circular(3))),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  child: Text(title),
                  padding: const EdgeInsets.all(5.0),
                ),
                IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Clear',
                    onPressed: controller.clear),
              ]),
              // DrawBar(_controller),
              const Divider(height: 5.0, thickness: 1.0),
              AspectRatio(
                aspectRatio: 3.0,
                child: Painter(controller),
              ),
              const Divider(height: 5.0, thickness: 1.0),
            ])));
  }
}
