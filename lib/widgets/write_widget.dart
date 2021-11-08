import 'package:flutter/material.dart';
import 'package:ink_test2/widgets/painter.dart';

class WriteWidget extends StatelessWidget {
  final String title;
  final PainterController controller;
  final bool pen;

  const WriteWidget(this.title, this.controller, {this.pen = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.undo),
                        tooltip: 'Undo',
                        onPressed: controller.undo),
                    IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Clear',
                        onPressed: controller.clear)
                  ],
                )
              ]),
              // DrawBar(_controller),
              const Divider(height: 5.0, thickness: 1.0),
              AspectRatio(
                aspectRatio: 3.0,
                child: Painter(controller, usePen: pen),
              ),
              const Divider(height: 5.0, thickness: 1.0),
            ])));
  }
}
