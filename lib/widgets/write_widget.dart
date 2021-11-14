import 'package:flutter/material.dart';
import 'package:ink2brain/widgets/painter.dart';

class WriteWidget extends StatefulWidget {
  final String title;
  final PainterController controller;
  final bool pen;

  const WriteWidget(this.title, this.controller, {this.pen = false, Key? key})
      : super(key: key);

  @override
  _WriteWidgetState createState() => _WriteWidgetState();
}

class _WriteWidgetState extends State<WriteWidget> {
//class WriteWidget extends StatelessWidget {

  //const WriteWidget(this.title, this.controller, {this.pen = false, Key? key})
  //    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.center,
          child: AspectRatio(
              aspectRatio: 3, //3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 1.5),
                  //borderRadius: const BorderRadius.all(Radius.circular(3))
                ),
                child: Stack(alignment: Alignment.topRight, children: [
                  Painter(widget.controller, usePen: widget.pen),
                  Positioned(
                      //alignment: Alignment.topRight,
                      right: 0,
                      // height: 100,
                      child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(children: [
                            RotatedBox(
                                quarterTurns:
                                    widget.controller.eraseMode ? 1 : 0,
                                child: IconButton(
                                    icon: const Icon(Icons.create),
                                    tooltip: (widget.controller.eraseMode
                                            ? 'Disable'
                                            : 'Enable') +
                                        ' eraser',
                                    onPressed: () {
                                      setState(() {
                                        widget.controller.eraseMode =
                                            !widget.controller.eraseMode;
                                        widget.controller.thickness =
                                            widget.controller.eraseMode
                                                ? 6.0
                                                : 1.5;
                                      });
                                    })),
                            IconButton(
                                splashRadius: 10.0,
                                icon: const Icon(Icons.undo),
                                tooltip: 'Undo',
                                onPressed: widget.controller.undo),
                            IconButton(
                                splashRadius: 10.0,
                                icon: const Icon(Icons.delete),
                                tooltip: 'Clear',
                                onPressed: widget.controller.clear)
                          ])))
                ]),
              )),
        ));
  }
}
