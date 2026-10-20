import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:ink2brain/database_con.dart';
import 'package:ink2brain/journal_edit.dart';
import 'package:ink2brain/models/journal_entry.dart';

class JournalListPage extends StatefulWidget {
  const JournalListPage({super.key});

  @override
  JournalListPageState createState() => JournalListPageState();
}

class JournalListPageState extends State<JournalListPage> {
  List<JournalEntry> _entries = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await DatabaseCon().journalEntries();
    if (!mounted) return;
    setState(() {
      _entries = entries;
    });
  }

  void _editEntry(JournalEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => JournalEditPage(editId: entry.id)),
    ).then((value) => _loadEntries());
  }

  void _newEntry() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const JournalEditPage()),
    ).then((value) => _loadEntries());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(35.0),
          child: AppBar(
            title: const Text('journal'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'write journal',
                onPressed: _newEntry,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'refresh',
                onPressed: _loadEntries,
              ),
            ],
          )),
      body: _entries.isEmpty
          ? const Center(child: Text('no journal entries yet'))
          : Scrollbar(
              controller: _scrollController,
              thumbVisibility:
                  Platform.isWindows || Platform.isLinux || Platform.isMacOS,
              child: ListView.separated(
                controller: _scrollController,
                itemCount: _entries.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  return ListTile(
                    title: Text(
                      entry.getPreview(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(entry.getInsertDateStr()),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editEntry(entry),
                    ),
                    onTap: () => _editEntry(entry),
                  );
                },
              ),
            ),
    );
  }
}
