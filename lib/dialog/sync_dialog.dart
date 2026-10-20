import 'package:material_ui/material_ui.dart';
import 'package:ink2brain/database_con.dart';
import 'package:ink2brain/l10n/app_localizations.dart';
import 'package:ink2brain/utils/nextcloud.dart';

class SyncDialog extends StatefulWidget {
  const SyncDialog({super.key});

  @override
  SyncDialogStat createState() => SyncDialogStat();
}

class SyncDialogStat extends State<SyncDialog> {
  String errorMessage = "";
  bool _busy = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _uploadDb() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      errorMessage = l10n.loading;
    });
    await DatabaseCon().closeCon();
    String res = await ncUploadFile();
    setState(() {
      _busy = false;
      errorMessage = l10n.uploadResult(res);
    });
    await DatabaseCon().openCon();
  }

  Future<void> _downloadDb() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      errorMessage = l10n.loading;
    });
    await DatabaseCon().closeCon();
    String res = await ncDownloadFile();
    setState(() {
      _busy = false;
      errorMessage = l10n.downloadResult(res);
    });
    await DatabaseCon().openCon();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Widget doneButton = OutlinedButton(
        child: Text(l10n.done),
        onPressed: () {
          Navigator.pop(context);
        });
    return AlertDialog(
        actions: [doneButton],
        title: Row(children: [
          const Icon(Icons.sync),
          const SizedBox(
            width: 10,
          ),
          Text(l10n.syncDatabase, style: const TextStyle(fontSize: 14))
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
                        child: Text(l10n.downloadOverwrite)),
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
                        child: Text(l10n.uploadLocalDb)),
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
                        color: _busy || errorMessage.contains("OK")
                            ? Colors.black
                            : Colors.red))
              ],
            ))));
  }
}
