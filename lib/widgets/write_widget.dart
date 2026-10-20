import 'package:material_ui/material_ui.dart';
import 'package:ink2brain/l10n/app_localizations.dart';
import 'package:ink2brain/widgets/painter.dart';

class WriteWidget extends StatefulWidget {
  final PainterController controller;
  final bool pen;

  const WriteWidget(this.controller, {this.pen = false, super.key});

  @override
  WriteWidgetState createState() => WriteWidgetState();
}

class WriteWidgetState extends State<WriteWidget> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Align(
          alignment: Alignment.center,
          child: AspectRatio(
              aspectRatio: 3, //3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 1.5),
                ),
                child: Stack(alignment: Alignment.topRight, children: [
                  Painter(widget.controller, usePen: widget.pen),
                  Positioned(
                      right: 0,
                      child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(children: [
                            RotatedBox(
                                quarterTurns:
                                    widget.controller.eraseMode ? 1 : 0,
                                child: IconButton(
                                    icon: const Icon(Icons.create),
                                    tooltip: widget.controller.eraseMode
                                        ? l10n.disableEraser
                                        : l10n.enableEraser,
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
                                tooltip: l10n.undo,
                                onPressed: widget.controller.undo),
                            IconButton(
                                splashRadius: 10.0,
                                icon: const Icon(Icons.delete),
                                tooltip: l10n.clear,
                                onPressed: widget.controller.clear)
                          ])))
                ]),
              )),
        ));
  }
}
