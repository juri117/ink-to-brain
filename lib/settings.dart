import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:ink2brain/l10n/app_localizations.dart';
import 'package:ink2brain/locale_controller.dart';
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
  String appLanguage = 'en';
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
    await prefs.setString("nextcloud_host", nextcloudHostController.text);
    await prefs.setString("nextcloud_user", nextcloudUserController.text);
    await prefs.setString("nextcloud_pw", nextcloudPwController.text);
    await prefs.setBool("use_text_if_exists", useTextIfExists);
    await prefs.setString("journal_practice_lang", practiceLang);
    await prefs.setString("journal_primary_lang", primaryLang);
    await localeController.setLanguage(appLanguage);
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
      final savedLanguage =
          prefs.getString(LocaleController.prefKey) ?? 'en';
      appLanguage =
          LocaleController.options.containsKey(savedLanguage) ? savedLanguage : 'en';
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(35.0), // here the desired height
          child: AppBar(
            title: Text(l10n.settingsTitle),
          )),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
            child: Card(
                child: ListView(children: [
          ListTile(
              title: Text(l10n.appLanguage),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: DropdownButtonFormField<String>(
                  key: ValueKey(appLanguage),
                  initialValue: appLanguage,
                  items: LocaleController.options.entries
                      .map((entry) => DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(entry.value),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary)),
                  ),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      appLanguage = v;
                    });
                  },
                ),
              )),
          ListTile(
              title: Text(l10n.nextcloudLogin),
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
                                hintText: l10n.hostHint,
                                labelText: l10n.hostLabel,
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
                                hintText: l10n.userHint,
                                labelText: l10n.username,
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
                                hintText: l10n.pwHint,
                                labelText: l10n.password,
                              ))),
                    ],
                  ),
                ],
              )),
          ListTile(
              title: Text(l10n.journalLanguages),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: practiceLang,
                    items: _langItems,
                    decoration: InputDecoration(
                      labelText: l10n.practiceLanguage,
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
                      labelText: l10n.primaryLanguage,
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
                    l10n.offlineTranslationNote,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              )),
          ListTile(
              title: Text(l10n.misc),
              subtitle: CheckboxListTile(
                  title: Text(l10n.useTextIfExisting),
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
        tooltip: l10n.storeSettings,
        child: const Icon(Icons.save),
      ),
    );
  }
}
