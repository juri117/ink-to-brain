import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ink2brain/database_con.dart';
import 'package:ink2brain/models/word.dart';
import 'package:ink2brain/widgets/painter.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

class NewWordPage extends StatefulWidget {
  final int? editId;

  const NewWordPage({this.editId, Key? key}) : super(key: key);

  @override
  NewWordPageState createState() => NewWordPageState();
}

class NewWordPageState extends State<NewWordPage>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;

  final PainterController _questPaintControl = _newController();
  final PainterController _answPaintControl = _newController();

  final TextEditingController _questTxtControl = TextEditingController();
  final TextEditingController _answTxtControl = TextEditingController();

  //final ScrollController _scrollControl = ScrollController();
  //final ScrollController _scrollControl2 = ScrollController();

  Word editWord = Word(
      id: -1,
      insertTs: DateTime.fromMicrosecondsSinceEpoch(0),
      questionPix: Uint8List(0),
      questionTxt: "",
      answerPix: Uint8List(0),
      answerTxt: "",
      correctCount: 0,
      correctCountRev: 0);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
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
    //Uint8List questPix = await _questPaintControl.finish().toPNG();
    //Uint8List answPix = await _answPaintControl.finish().toPNG();

    if (widget.editId == null) {
      /*
      Uint8List? questBytes = img.decodePng(questPix)?.getBytes();
      bool questIsEmpty = true;
      for (final pix in questBytes ?? []) {
        if (pix != 0) {
          questIsEmpty = false;
          break;
        }
      }
      Uint8List? answBytes = img.decodePng(answPix)?.getBytes();
      bool answIsEmpty = true;
      for (final pix in answBytes ?? []) {
        if (pix != 0) {
          answIsEmpty = false;
          break;
        }
      }
      */
      DatabaseCon().insertWord(Word(
          id: -1,
          insertTs: DateTime.now(),
          questionPix: null,
          questionTxt: _questTxtControl.text.trim(),
          answerPix: null,
          answerTxt: _answTxtControl.text.trim(),
          correctCount: 0,
          correctCountRev: 0));
    } else {
      DatabaseCon().updateWord(Word(
          id: widget.editId!,
          insertTs: editWord.insertTs,
          questionPix: _questPaintControl.isEmpty ? editWord.questionPix : null,
          questionTxt: _questTxtControl.text.trim(),
          answerPix: _answPaintControl.isEmpty ? editWord.answerPix : null,
          answerTxt: _answTxtControl.text.trim(),
          correctCount: editWord.correctCount,
          correctCountRev: editWord.correctCountRev,
          lastAskedTs: editWord.lastAskedTs,
          lastAskedRevTs: editWord.lastAskedRevTs));
    }
  }

  Future<void> _delete(BuildContext context) async {
    DatabaseCon().deleteWord(widget.editId ?? -1);
    Navigator.pop(context);
  }

/*
  Future<void> _scanQuest() async {
    await requestWritePermission();

    Uint8List? pix = (editWord.id > 0 && _questPaintControl.isEmpty)
        ? editWord.questionPix
        : await _questPaintControl.generateRendering().toPNG();
    if (pix != null) {
      Directory? directory;
      if (Platform.isWindows) {
        directory = Directory.current;
      } else {
        directory = await getExternalStorageDirectory();
      }
      final String fOutPath = join(directory!.path, "tmpQuestImg.png");
      final File fOut = File(fOutPath);
      fOut.writeAsBytes(pix);

      String langName = "deu";
      String text = await FlutterTesseractOcr.extractText(fOutPath,
          language: langName,
          args: {
            "psm": "7",
          });

      setState(() {
        _questTxtControl.text = text;
      });
    }
  }

  Future<void> _scanAnsw() async {
    await requestWritePermission();

    Uint8List? pix = (editWord.id > 0 && _answPaintControl.isEmpty)
        ? editWord.answerPix
        : await _answPaintControl.generateRendering().toPNG();
    if (pix != null) {
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
          });

      setState(() {
        _answTxtControl.text = text;
      });
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    Widget buttons =
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      widget.editId == null
          ? const Text('')
          : OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: const Color(0xFFFFE4E4)),
              icon: const Icon(Icons.delete),
              label: const Text('delete'),
              onPressed: () {
                _delete(context);
              },
            ),
      OutlinedButton.icon(
        icon: const Icon(Icons.save),
        label: Text(widget.editId == null ? 'save' : 'edit'),
        onPressed: () {
          _save(context);
          if (mounted) Navigator.pop(context);
        },
      )
    ]);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(35.0),
          child: AppBar(
            title: const Text("add questions"),
          )),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(5),
              child: Row(children: [
                Expanded(
                    flex: 1,
                    child: TextField(
                        controller: _questTxtControl,
                        minLines: 1, //Normal textInputField will be displayed
                        maxLines:
                            1, // when user presses enter it will adapt to it
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                          hintText: '...',
                          labelText: 'Question Note',
                        ))),
                const SizedBox(
                  width: 10,
                ),
              ])),
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
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                          hintText: '...',
                          labelText: 'Answer Note',
                        ))),
                const SizedBox(
                  width: 10,
                ),
              ])),
          buttons
        ],
      ),
    );
  }
}
