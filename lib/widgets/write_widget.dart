import 'package:flutter/material.dart';
import 'package:ink2brain/widgets/painter.dart';

class WriteWidget extends StatelessWidget {
  final String title;
  final PainterController controller;
  final bool pen;

  const WriteWidget(this.title, this.controller, {this.pen = false, Key? key})
      : super(key: key);

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
                  Painter(controller, usePen: pen),
                  Positioned(
                      //alignment: Alignment.topRight,
                      right: 0,
                      // height: 100,
                      child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(children: [
                            IconButton(
                                splashRadius: 10.0,
                                icon: const Icon(Icons.undo),
                                tooltip: 'Undo',
                                onPressed: controller.undo),
                            IconButton(
                                splashRadius: 10.0,
                                icon: const Icon(Icons.delete),
                                tooltip: 'Clear',
                                onPressed: controller.clear)
                          ])))
                ]),
              )),
        ));
    /*
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 1.5),
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
          Align(
              alignment: Alignment.bottomCenter,
              child: AspectRatio(
                aspectRatio: 3,
                child: Painter(controller, usePen: pen),
              )),
          const Divider(height: 5.0, thickness: 1.0),
        ]));
        */
  }
}
