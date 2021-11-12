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
              child: Column(children: [
                const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Question", style: TextStyle(fontSize: 20))),
                WriteWidget("word to learn", _controller, pen: true)
              ])),
          Expanded(
              flex: 1,
              child: Column(children: [
                const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Answer", style: TextStyle(fontSize: 20))),
                WriteWidget("hint", _controllerTrans, pen: true)
              ])),
        ],
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        SizedBox(
            width: 200.0,
            height: 100.0,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('save'),
              //style: OutlinedButton.styleFrom(
              //primary: Colors.green,
              //backgroundColor: const Color(0xFFE4FFE6)),
              onPressed: () {
                _save();
              },
            ))
      ])
    ]);
  }
}
