import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:ink2brain/database_con.dart';
import 'package:ink2brain/models/word.dart';
import 'package:ink2brain/utils/file_utils.dart';
import 'package:ink2brain/widgets/painter.dart';
import 'package:ink2brain/widgets/write_widget.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class NewWordPage extends StatefulWidget {
  const NewWordPage({Key? key}) : super(key: key);

  @override
  _NewWordPageState createState() => _NewWordPageState();
}

class _NewWordPageState extends State<NewWordPage> {
  //bool _finished = false;
  PainterController _questPaintControl = _newController();
  PainterController _answPaintControl = _newController();

  final TextEditingController _questTxtControl = TextEditingController();
  final TextEditingController _answTxtControl = TextEditingController();

  final ScrollController _scrollControl = ScrollController();

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
    Uint8List questPix = await _questPaintControl.finish().toPNG();
    Uint8List answPix = await _answPaintControl.finish().toPNG();

    DatabaseCon().insertWord(Word(
        id: -1,
        insertTs: DateTime.now(),
        questionPix: questPix,
        questionTxt: "",
        answerPix: answPix,
        answerTxt: "",
        correctCount: 0));

    setState(() {
      _questPaintControl = _newController();
      _answPaintControl = _newController();
    });
  }

  Future<void> _scanQuest() async {
    await requestWritePermission();
    Uint8List pix = await _questPaintControl.generateRendering().toPNG();
    Directory? directory;
    if (Platform.isWindows) {
      directory = Directory.current;
    } else {
      directory = await getExternalStorageDirectory();
    }
    final String fOutPath = join(directory!.path, "tmpQuestImg.png");
    final File fOut = File(fOutPath);
    fOut.writeAsBytes(pix);

    /*
    final inputImage = InputImage.fromFile(fOut);
    final digitalInkRecogniser = GoogleMlKit.vision.digitalInkRecogniser();
    final List<RecognitionCandidate> canditates =
        await digitalInkRecogniser.readText(points, languageTag);
    for (final candidate in candidates) {
      final text = candidate.text;
      final score = candidate.score;
    }
    digitalInkRecogniser.close();
    */

    String langName = "deu";
    String text = await FlutterTesseractOcr.extractText(fOutPath,
        language: langName,
        args: {
          "psm": "7",
          //"preserve_interword_spaces": "1",
        });

    setState(() {
      _questTxtControl.text = text;
    });
  }

  Future<void> _scanAnsw() async {
    await requestWritePermission();
    Uint8List pix = await _answPaintControl.generateRendering().toPNG();
    final Directory? directory = await getExternalStorageDirectory();
    final String fOutPath = join(directory!.path, "tmpAnswImg.png");
    final File fOut = File(fOutPath);
    fOut.writeAsBytes(pix);

    String langName = "vie";

    String text = await FlutterTesseractOcr.extractText(fOutPath,
        language: langName,
        args: {
          "psm": "7",
          //"preserve_interword_spaces": "1",
        });

    setState(() {
      _answTxtControl.text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("add questions"),
        ),
        body: Scrollbar(
            controller: _scrollControl,
            isAlwaysShown:
                Platform.isWindows || Platform.isLinux || Platform.isMacOS,
            child: SingleChildScrollView(
                controller: _scrollControl,
                child: Column(children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Column(children: [
                            const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text("Question",
                                    style: TextStyle(fontSize: 20))),
                            WriteWidget("word to learn", _questPaintControl,
                                pen: true),
                            Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(children: [
                                  Expanded(
                                      flex: 1,
                                      child: TextField(
                                          controller: _questTxtControl,
                                          minLines:
                                              1, //Normal textInputField will be displayed
                                          maxLines:
                                              1, // when user presses enter it will adapt to it
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary)),
                                            hintText: '...',
                                            labelText: 'Question Note',
                                          ))),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.lightbulb_outline),
                                    onPressed: Platform.isWindows
                                        ? null
                                        : () {
                                            _scanQuest();
                                          },
                                  )
                                ])),
                          ])),
                      Expanded(
                          flex: 1,
                          child: Column(children: [
                            const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text("Answer",
                                    style: TextStyle(fontSize: 20))),
                            WriteWidget("hint", _answPaintControl, pen: true),
                            Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(children: [
                                  Expanded(
                                      flex: 1,
                                      child: TextField(
                                          controller: _answTxtControl,
                                          minLines: 1,
                                          maxLines: 1,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary)),
                                            hintText: '...',
                                            labelText: 'Answer Note',
                                          ))),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.lightbulb_outline),
                                    onPressed: Platform.isWindows
                                        ? null
                                        : () {
                                            _scanAnsw();
                                          },
                                  )
                                ])),
                          ])),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
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
                ]))));
  }
}
