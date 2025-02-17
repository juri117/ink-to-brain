import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const String tag = "TablePage";

class WordDisplay extends StatefulWidget {
  final Uint8List? wordPix;
  final String wordTxt;
  final bool showTxtIfPresent;
  final bool isVisible;
  const WordDisplay(this.wordPix, this.wordTxt, this.showTxtIfPresent,
      {this.isVisible = false, Key? key})
      : super(key: key);
  @override
  WordDisplayState createState() => WordDisplayState();
}

class WordDisplayState extends State<WordDisplay> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: AspectRatio(
            aspectRatio: 3,
            child: widget.isVisible
                ? Center(
                    child: Icon(Icons.visibility_off,
                        size: 40, color: Theme.of(context).primaryColor))
                : (widget.wordTxt != "" && widget.showTxtIfPresent)
                    ? FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          widget.wordTxt,
                          style: const TextStyle(fontSize: 25),
                        ))
                    : (widget.wordPix != null)
                        ? ((widget.wordPix!.isNotEmpty)
                            ? Image.memory(widget.wordPix!)
                            : (widget.wordTxt != "")
                                ? FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      widget.wordTxt,
                                      style: const TextStyle(fontSize: 25),
                                    ))
                                : const Text("loading..."))
                        : const Text("empty")));
  }
}
