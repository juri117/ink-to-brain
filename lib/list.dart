import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ink2brain/database_con.dart';
import 'package:ink2brain/models/word.dart';
import 'package:ink2brain/new_words.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Word> words = [];

  int _currentSortColumn = 0;
  bool _isAscending = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    List<Word> newWords = await DatabaseCon().words(orderBy: "insertTs");
    setState(() {
      newWords.shuffle();
      words = newWords;
      _sort(_currentSortColumn, _isAscending);
    });
  }

  Future<void> _sort(int columnIndex, bool ascending) async {
    setState(() {
      _currentSortColumn = columnIndex;
      _isAscending = ascending;
      switch (columnIndex) {
        case 0:
          words
              .sort((dataA, dataB) => dataB.insertTs.compareTo(dataA.insertTs));
          break;
        case 2:
          words.sort((dataA, dataB) =>
              dataB.correctCount.compareTo(dataA.correctCount));
          break;
        case 4:
          words.sort((dataA, dataB) =>
              dataB.correctCount.compareTo(dataA.correctCount));
          break;
        case 5:
          words.sort((dataA, dataB) =>
              dataB.correctCount.compareTo(dataA.correctCount));
          break;
        case 6:
          words.sort((dataA, dataB) => (dataB.lastAskedTs ??
                  DateTime.fromMicrosecondsSinceEpoch(0))
              .compareTo(
                  dataA.lastAskedTs ?? DateTime.fromMicrosecondsSinceEpoch(0)));
          break;
      }
      if (!ascending) {
        words = List.from(words.reversed);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(35.0), // here the desired height
            child: AppBar(
              title: const Text("list"),
            )),
        body: Scrollbar(
            controller: _scrollController,
            isAlwaysShown:
                Platform.isWindows || Platform.isLinux || Platform.isMacOS,
            child: SingleChildScrollView(
                controller: _scrollController,
                child: LayoutBuilder(
                    builder: (context, constraints) => ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                            columnSpacing: 5.0,
                            sortColumnIndex: _currentSortColumn,
                            sortAscending: _isAscending,
                            columns: <DataColumn>[
                              DataColumn(
                                  label: const Text('added'),
                                  onSort: (columnIndex, ascending) {
                                    _sort(columnIndex, ascending);
                                  }),
                              const DataColumn(label: Text('question')),
                              DataColumn(
                                  label: const Text('note'),
                                  onSort: (columnIndex, ascending) {
                                    _sort(columnIndex, ascending);
                                  }),
                              const DataColumn(label: Text('answer')),
                              DataColumn(
                                  label: const Text('note'),
                                  onSort: (columnIndex, ascending) {
                                    _sort(columnIndex, ascending);
                                  }),
                              DataColumn(
                                  label: const Text('correct'),
                                  onSort: (columnIndex, ascending) {
                                    _sort(columnIndex, ascending);
                                  }),
                              DataColumn(
                                  label: const Text('last asked'),
                                  onSort: (columnIndex, ascending) {
                                    _sort(columnIndex, ascending);
                                  }),
                              const DataColumn(label: Text(''))
                            ],
                            rows: List<DataRow>.generate(
                                words.length,
                                (int index) => DataRow(
                                      color: MaterialStateProperty.resolveWith<
                                          Color?>((Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.selected)) {
                                          return Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.08);
                                        }
                                        if (index.isEven) {
                                          return Colors.grey.withOpacity(0.1);
                                        }
                                        return null;
                                      }),
                                      cells: <DataCell>[
                                        DataCell(AspectRatio(
                                            aspectRatio: 3.0,
                                            child: Text(words[index]
                                                .getInsertDateStr()))),
                                        DataCell(SizedBox(
                                            width: 120,
                                            child: AspectRatio(
                                                aspectRatio: 3.0,
                                                child: Image.memory(words[index]
                                                    .questionPix)))),
                                        DataCell(
                                            Text(words[index].questionTxt)),
                                        DataCell(SizedBox(
                                            width: 120,
                                            child: AspectRatio(
                                                aspectRatio: 3.0,
                                                child: Image.memory(
                                                    words[index].answerPix)))),
                                        DataCell(Text(words[index].answerTxt)),
                                        DataCell(Text(
                                            "${words[index].correctCount}")),
                                        DataCell(Text(words[index]
                                            .getlastAskedDateStr())),
                                        DataCell(
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            tooltip: 'edit',
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewWordPage(
                                                            editId: words[index]
                                                                .id)),
                                              ).then((value) => _loadWords());
                                            },
                                          ),
                                        ),
                                      ],
                                    ))))))));
  }
}
