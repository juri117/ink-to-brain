import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return const SharedPreferencesScreen();
  }
}

class SharedPreferencesScreen extends StatefulWidget {
  const SharedPreferencesScreen({super.key});

  @override
  SharedPreferencesScreenState createState() => SharedPreferencesScreenState();
}

class SharedPreferencesScreenState extends State<SharedPreferencesScreen> {
  final nextcloudHostController = TextEditingController();
  final nextcloudUserController = TextEditingController();
  final nextcloudPwController = TextEditingController();

  bool useTextIfExists = false;
  String practiceLang = 'vi';
  String primaryLang = 'de';

  List<DropdownMenuItem<String>> get _langItems {
    final langs = List<TranslateLanguage>.from(TranslateLanguage.values)
      ..sort((a, b) => a.name.compareTo(b.name));
    return langs
        .map((l) => DropdownMenuItem<String>(
              value: l.bcpCode,
              child: Text('${l.name} (${l.bcpCode})'),
            ))
        .toList();
  }

  Future<void> _store() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("nextcloud_host", nextcloudHostController.text);
    prefs.setString("nextcloud_user", nextcloudUserController.text);
    prefs.setString("nextcloud_pw", nextcloudPwController.text);
    prefs.setBool("use_text_if_exists", useTextIfExists);
    prefs.setString("journal_practice_lang", practiceLang);
    prefs.setString("journal_primary_lang", primaryLang);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nextcloudHostController.text = prefs.getString('nextcloud_host') ?? "";
      nextcloudUserController.text = prefs.getString('nextcloud_user') ?? "";
      nextcloudPwController.text = prefs.getString('nextcloud_pw') ?? "";
      useTextIfExists = prefs.getBool('use_text_if_exists') ?? false;
      practiceLang = prefs.getString('journal_practice_lang') ?? 'vi';
      primaryLang = prefs.getString('journal_primary_lang') ?? 'de';
    });
  }

  @override
  void dispose() {
    nextcloudHostController.dispose();
    nextcloudUserController.dispose();
    nextcloudPwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(35.0), // here the desired height
          child: AppBar(
            title: const Text("Settings"),
          )),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
            child: Card(
                child: ListView(children: [
          ListTile(
              title: const Text("nextcloud login"),
              subtitle: Column(
                children: [
                  Wrap(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(8),
                          width: 200,
                          child: TextField(
                              controller: nextcloudHostController,
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
                                hintText: 'host.url',
                                labelText: 'host-url/ip',
                              ))),
                      Container(
                          padding: const EdgeInsets.all(8),
                          width: 200,
                          child: TextField(
                              controller: nextcloudUserController,
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
                                hintText: 'user',
                                labelText: 'username',
                              ))),
                      Container(
                          padding: const EdgeInsets.all(8),
                          width: 200,
                          child: TextField(
                              controller: nextcloudPwController,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
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
                                hintText: 'pw',
                                labelText: 'password',
                              ))),
                    ],
                  ),
                ],
              )),
          ListTile(
              title: const Text("journal languages"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: practiceLang,
                    items: _langItems,
                    decoration: InputDecoration(
                      labelText: 'practice language',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary)),
                    ),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() {
                        practiceLang = v;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: primaryLang,
                    items: _langItems,
                    decoration: InputDecoration(
                      labelText: 'primary language (translation)',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary)),
                    ),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() {
                        primaryLang = v;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Offline translation uses Android ML Kit. Language models download on demand when you open the journal.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              )),
          ListTile(
              title: const Text("misc."),
              subtitle: CheckboxListTile(
                  title: const Text("use text if existing (not the doodle)"),
                  value: useTextIfExists,
                  onChanged: (bool? value) {
                    if (!mounted) return;
                    setState(() {
                      useTextIfExists = !useTextIfExists;
                    });
                  }))
        ])))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _store,
        tooltip: 'store settings',
        child: const Icon(Icons.save),
      ),
    );
  }
}
