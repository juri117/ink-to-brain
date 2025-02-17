import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SharedPreferencesScreen();
  }
}

class SharedPreferencesScreen extends StatefulWidget {
  const SharedPreferencesScreen({Key? key}) : super(key: key);

  @override
  SharedPreferencesScreenState createState() => SharedPreferencesScreenState();
}

class SharedPreferencesScreenState extends State<SharedPreferencesScreen> {
  final nextcloudHostController = TextEditingController();
  final nextcloudUserController = TextEditingController();
  final nextcloudPwController = TextEditingController();

  bool useTextIfExists = false;

  Future<void> _store() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("nextcloud_host", nextcloudHostController.text);
    prefs.setString("nextcloud_user", nextcloudUserController.text);
    prefs.setString("nextcloud_pw", nextcloudPwController.text);
    prefs.setBool("use_text_if_exists", useTextIfExists);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    setState(() {
      nextcloudHostController.text = prefs.getString('nextcloud_host') ?? "";
      nextcloudUserController.text = prefs.getString('nextcloud_user') ?? "";
      nextcloudPwController.text = prefs.getString('nextcloud_pw') ?? "";
      useTextIfExists = prefs.getBool('use_text_if_exists') ?? false;
    });
  }

  @override
  void dispose() {
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
                child: Column(children: [
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
