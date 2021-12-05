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
// import 'package:google_ml_kit/google_ml_kit.dart';

class NewWordPage extends StatefulWidget {
  final int? editId;

  const NewWordPage({this.editId, Key? key}) : super(key: key);

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

  Word editWord = Word(
      id: -1,
      insertTs: DateTime.fromMicrosecondsSinceEpoch(0),
      questionPix: Uint8List(0),
      questionTxt: "",
      answerPix: Uint8List(0),
      answerTxt: "",
      correctCount: 0);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  static PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 2.0;
    controller.drawColor = Colors.blue[900]!;
    controller.backgroundColor = Colors.transparent;
    return controller;
  }

  Future<void> _loadData() async {
    if (widget.editId != null) {
      List<Word> newWords =
          await DatabaseCon().words(where: "id = ${widget.editId}");
      if (newWords.isNotEmpty) {
        setState(() {
          editWord = newWords[0];
          _questTxtControl.text = editWord.questionTxt;
          _answTxtControl.text = editWord.answerTxt;
        });
      }
    }
  }

  Future<void> _save(BuildContext context) async {
    Uint8List questPix = await _questPaintControl.finish().toPNG();
    Uint8List answPix = await _answPaintControl.finish().toPNG();
    if (widget.editId == null) {
      DatabaseCon().insertWord(Word(
          id: -1,
          insertTs: DateTime.now(),
          questionPix: questPix,
          questionTxt: _questTxtControl.text,
          answerPix: answPix,
          answerTxt: _answTxtControl.text,
          correctCount: 0));
    } else {
      DatabaseCon().updateWord(Word(
          id: widget.editId!,
          insertTs: editWord.insertTs,
          questionPix:
              _questPaintControl.isEmpty ? editWord.questionPix : questPix,
          questionTxt: _questTxtControl.text,
          answerPix: _answPaintControl.isEmpty ? editWord.answerPix : answPix,
          answerTxt: _answTxtControl.text,
          correctCount: editWord.correctCount));
      Navigator.pop(context);
    }

    setState(() {
      _questPaintControl = _newController();
      _answPaintControl = _newController();
    });
  }

  Future<void> _scanQuest() async {
    await requestWritePermission();

    Uint8List pix = (editWord.id > 0 && _questPaintControl.isEmpty)
        ? editWord.questionPix
        : await _questPaintControl.generateRendering().toPNG();
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

    Uint8List pix = (editWord.id > 0 && _answPaintControl.isEmpty)
        ? editWord.answerPix
        : await _answPaintControl.generateRendering().toPNG();

    // Uint8List pix = await _answPaintControl.generateRendering().toPNG();
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
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(35.0),
            child: AppBar(
              title: const Text("add questions"),
            )),
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
                            editWord.id <= 0
                                ? const Text("")
                                : Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                            aspectRatio: 3,
                                            child: Image.memory(
                                                editWord.questionPix))),
                                  ),
                            WriteWidget(_questPaintControl, pen: true),
                            Padding(
                                padding: const EdgeInsets.all(5),
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
                      const VerticalDivider(width: 5, thickness: 1),
                      Expanded(
                          flex: 1,
                          child: Column(children: [
                            const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text("Answer",
                                    style: TextStyle(fontSize: 20))),
                            editWord.id <= 0
                                ? const Text("")
                                : Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                            aspectRatio: 3,
                                            child: Image.memory(
                                                editWord.answerPix))),
                                  ),
                            WriteWidget(_answPaintControl, pen: true),
                            Padding(
                                padding: const EdgeInsets.all(5),
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
                            child: OutlinedButton.icon(
                          icon: const Icon(Icons.save),
                          label: Text(widget.editId == null ? 'save' : 'edit'),
                          onPressed: () {
                            _save(context);
                          },
                        ))
                      ])
                ]))));
  }
}
