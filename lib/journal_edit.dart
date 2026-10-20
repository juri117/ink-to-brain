import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:ink2brain/database_con.dart';
import 'package:ink2brain/models/journal_entry.dart';
import 'package:ink2brain/utils/translator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalEditPage extends StatefulWidget {
  final int? editId;

  const JournalEditPage({this.editId, super.key});

  @override
  JournalEditPageState createState() => JournalEditPageState();
}

class JournalEditPageState extends State<JournalEditPage> {
  final TextEditingController _practiceControl = TextEditingController();
  final TextEditingController _lookupControl = TextEditingController();
  final JournalTranslator _translator = JournalTranslator();

  JournalEntry? _existing;
  String _translation = '';
  String _lookupResult = '';
  String _practiceLang = 'vi';
  String _primaryLang = 'de';
  bool _translatorReady = false;
  bool _translatorBusy = false;
  String? _translatorError;

  Timer? _practiceDebounce;
  Timer? _lookupDebounce;

  @override
  void initState() {
    super.initState();
    _practiceControl.addListener(_onPracticeChanged);
    _lookupControl.addListener(_onLookupChanged);
    _init();
  }

  Future<void> _init() async {
    await _loadPrefs();
    await _loadEntry();
    await _prepareTranslator();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _practiceLang = prefs.getString('journal_practice_lang') ?? 'vi';
      _primaryLang = prefs.getString('journal_primary_lang') ?? 'de';
    });
  }

  Future<void> _loadEntry() async {
    if (widget.editId == null) return;
    final entries = await DatabaseCon()
        .journalEntries(where: 'id = ${widget.editId}');
    if (entries.isEmpty || !mounted) return;
    setState(() {
      _existing = entries.first;
      _practiceControl.text = _existing!.practiceTxt;
    });
  }

  Future<void> _prepareTranslator() async {
    if (!JournalTranslator.isAvailable) {
      if (!mounted) return;
      setState(() {
        _translatorReady = false;
        _translatorError = null;
      });
      return;
    }

    setState(() {
      _translatorBusy = true;
      _translatorError = null;
    });

    try {
      await _translator.ensureReady(
        practiceBcp: _practiceLang,
        primaryBcp: _primaryLang,
      );
      if (!mounted) return;
      setState(() {
        _translatorReady = true;
        _translatorBusy = false;
      });
      await _runPracticeTranslate();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _translatorReady = false;
        _translatorBusy = false;
        _translatorError = 'translation setup failed: $e';
      });
    }
  }

  void _onPracticeChanged() {
    _practiceDebounce?.cancel();
    _practiceDebounce = Timer(const Duration(milliseconds: 500), () {
      _runPracticeTranslate();
    });
  }

  void _onLookupChanged() {
    _lookupDebounce?.cancel();
    _lookupDebounce = Timer(const Duration(milliseconds: 400), () {
      _runLookupTranslate();
    });
  }

  Future<void> _runPracticeTranslate() async {
    if (!_translatorReady) return;
    final text = _practiceControl.text;
    try {
      final result = await _translator.translatePracticeToPrimary(text);
      if (!mounted) return;
      setState(() {
        _translation = result;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _translation = '';
        _translatorError = 'translate failed: $e';
      });
    }
  }

  Future<void> _runLookupTranslate() async {
    if (!_translatorReady) return;
    final text = _lookupControl.text;
    try {
      final result = await _translator.translatePrimaryToPractice(text);
      if (!mounted) return;
      setState(() {
        _lookupResult = result;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _lookupResult = '';
      });
    }
  }

  Future<void> _save(BuildContext context) async {
    final text = _practiceControl.text.trim();
    if (widget.editId == null) {
      await DatabaseCon().insertJournalEntry(JournalEntry(
        id: -1,
        insertTs: DateTime.now(),
        practiceTxt: text,
      ));
    } else {
      await DatabaseCon().updateJournalEntry(JournalEntry(
        id: widget.editId!,
        insertTs: _existing?.insertTs ?? DateTime.now(),
        updateTs: DateTime.now(),
        practiceTxt: text,
      ));
    }
    if (context.mounted) Navigator.pop(context);
  }

  Future<void> _delete(BuildContext context) async {
    await DatabaseCon().deleteJournalEntry(widget.editId ?? -1);
    if (context.mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _practiceDebounce?.cancel();
    _lookupDebounce?.cancel();
    _practiceControl.removeListener(_onPracticeChanged);
    _lookupControl.removeListener(_onLookupChanged);
    _practiceControl.dispose();
    _lookupControl.dispose();
    _translator.close();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      border: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.secondary)),
      hintText: '...',
      labelText: label,
      alignLabelWithHint: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttons =
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      widget.editId == null
          ? const Text('')
          : OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: const Color(0xFFFFE4E4)),
              icon: const Icon(Icons.delete),
              label: const Text('delete'),
              onPressed: () {
                _delete(context);
              },
            ),
      OutlinedButton.icon(
        icon: const Icon(Icons.save),
        label: Text(widget.editId == null ? 'save' : 'edit'),
        onPressed: () {
          _save(context);
        },
      )
    ]);

    Widget translationPanel;
    if (!JournalTranslator.isAvailable) {
      translationPanel = Text(
        'translation unavailable on this platform',
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            fontStyle: FontStyle.italic),
      );
    } else if (_translatorBusy) {
      translationPanel = const Row(children: [
        SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2)),
        SizedBox(width: 8),
        Text('downloading language models…'),
      ]);
    } else if (_translatorError != null && !_translatorReady) {
      translationPanel = Text(
        _translatorError!,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      );
    } else {
      translationPanel = SelectableText(
        _translation.isEmpty ? '…' : _translation,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondaryContainer),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(35.0),
          child: AppBar(
            title: Text(widget.editId == null ? 'write journal' : 'edit journal'),
          )),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: _practiceControl,
                expands: true,
                maxLines: null,
                minLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: _fieldDecoration('journal ($_practiceLang)'),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'translation ($_primaryLang)',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  translationPanel,
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _lookupControl,
                    minLines: 1,
                    maxLines: 2,
                    decoration: _fieldDecoration('lookup ($_primaryLang → $_practiceLang)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 48),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: SelectableText(
                      _lookupResult.isEmpty ? '…' : _lookupResult,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            buttons,
          ],
        ),
      ),
    );
  }
}
