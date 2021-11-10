import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ink2brain/database_con.dart';
import 'package:ink2brain/models/word.dart';
import 'package:ink2brain/widgets/painter.dart';
import 'package:ink2brain/widgets/write_widget.dart';

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
    controller.thickness = 2.0;
    controller.drawColor = Colors.blue[900]!;
    controller.backgroundColor = Colors.transparent;
    return controller;
  }

  Future<void> _save() async {
    Uint8List foreignPix = await _controller.finish().toPNG();
    Uint8List motherTounghePix = await _controllerTrans.finish().toPNG();

    DatabaseCon().insertWord(Word(
        id: -1,
        insertTs: DateTime.now(),
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
          Expanded(
              flex: 1,
              child: WriteWidget("word to learn", _controller, pen: true)),
          Expanded(
              flex: 1, child: WriteWidget("hint", _controllerTrans, pen: true)),
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
}
