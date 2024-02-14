import 'package:flutter/material.dart';
import 'package:ink2brain/database_con.dart';
import 'package:ink2brain/utils/nextcloud.dart';

class SyncDialog extends StatefulWidget {
  const SyncDialog({Key? key}) : super(key: key);

  @override
  SyncDialogStat createState() => SyncDialogStat();
}

class SyncDialogStat extends State<SyncDialog> {
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _uploadDb() async {
    setState(() {
      errorMessage = "loading...";
    });
    await DatabaseCon().closeCon();
    String res = await ncUploadFile();
    setState(() {
      errorMessage = "upload: $res";
    });
    await DatabaseCon().openCon();
  }

  Future<void> _downloadDb() async {
    setState(() {
      errorMessage = "loading...";
    });
    await DatabaseCon().closeCon();
    String res = await ncDownloadFile();
    setState(() {
      errorMessage = "download: $res";
    });
    await DatabaseCon().openCon();
  }

  @override
  Widget build(BuildContext context) {
    Widget doneButton = OutlinedButton(
        child: const Text("done"),
        onPressed: () {
          Navigator.pop(context);
        });
    return AlertDialog(
        actions: [doneButton],
        title: const Row(children: [
          Icon(Icons.sync),
          SizedBox(
            width: 10,
          ),
          Text("sync. database with nextcloud", style: TextStyle(fontSize: 14))
        ]),
        content: SizedBox(
            height: (MediaQuery.of(context).size.height),
            width: (MediaQuery.of(context).size.width),
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Wrap(children: <Widget>[
                  OutlinedButton.icon(
                    icon: const Icon(Icons.download),
                    label: Container(
                        //width: 150,
                        padding: const EdgeInsets.all(5),
                        child: const Text('download, overwrite db')),
                    onPressed: () {
                      _downloadDb();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.upload),
                    label: Container(
                        //width: 150,
                        padding: const EdgeInsets.all(5),
                        child: const Text('upload local db')),
                    onPressed: () {
                      _uploadDb();
                    },
                  ),
                ]),
                const SizedBox(
                  height: 10,
                ),
                Text(errorMessage,
                    style: TextStyle(
                        color: errorMessage.contains("OK") ||
                                errorMessage.contains("loading...")
                            ? Colors.black
                            : Colors.red))
              ],
            ))));
  }
}
