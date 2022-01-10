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
  List<Word> filteredWords = [];

  int _currentSortColumn = 0;
  bool _isAscending = true;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchTxtControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords({String searchWord: ""}) async {
    List<Word> newWords = [];
    if (searchWord.isNotEmpty) {
      newWords = await DatabaseCon().words(
          orderBy: "insertTs",
          where:
              "questionTxt LIKE '%$searchWord%' OR answerTxt LIKE '%$searchWord%'");
    } else {
      newWords = await DatabaseCon().words(orderBy: "insertTs");
    }
    setState(() {
      newWords.shuffle();
      words = newWords;
      filteredWords = words;
      _sort(_currentSortColumn, _isAscending);
    });
  }

  Future<void> _filterWords({String searchWord: ""}) async {
    setState(() {
      if (searchWord.isNotEmpty) {
        filteredWords = words
            .where((w) =>
                w.questionTxt
                    .toLowerCase()
                    .contains(searchWord.toLowerCase()) ||
                w.answerTxt.toLowerCase().contains(searchWord.toLowerCase()))
            .toList();
      } else {
        filteredWords = words;
      }
    });
  }

  Future<void> _sort(int columnIndex, bool ascending) async {
    setState(() {
      _currentSortColumn = columnIndex;
      _isAscending = ascending;
      switch (columnIndex) {
        case 0:
          filteredWords
              .sort((dataA, dataB) => dataB.insertTs.compareTo(dataA.insertTs));
          break;
        case 2:
          filteredWords.sort((dataA, dataB) =>
              dataB.correctCount.compareTo(dataA.correctCount));
          break;
        case 4:
          filteredWords.sort((dataA, dataB) =>
              dataB.correctCount.compareTo(dataA.correctCount));
          break;
        case 5:
          filteredWords.sort((dataA, dataB) =>
              dataB.correctCount.compareTo(dataA.correctCount));
          break;
        case 6:
          filteredWords.sort((dataA, dataB) => (dataB.lastAskedTs ??
                  DateTime.fromMicrosecondsSinceEpoch(0))
              .compareTo(
                  dataA.lastAskedTs ?? DateTime.fromMicrosecondsSinceEpoch(0)));
          break;
      }
      if (!ascending) {
        filteredWords = List.from(filteredWords.reversed);
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
        body: Column(children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 300,
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                        controller: _searchTxtControl,
                        onSubmitted: (value) {
                          _filterWords(searchWord: _searchTxtControl.text);
                        },
                        minLines: 1, //Normal textInputField will be displayed
                        maxLines:
                            1, // when user presses enter it will adapt to it
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                          hintText: '...',
                          labelText: 'Question Note',
                          suffixIcon: IconButton(
                            // Icon to
                            icon: const Icon(Icons.clear,
                                color: Colors.grey), // clear text
                            onPressed: () {
                              setState(() {
                                _searchTxtControl.text = "";
                              });
                              _filterWords();
                            },
                          ),
                        ))),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  child: const Text("search"),
                  onPressed: () {
                    _filterWords(searchWord: _searchTxtControl.text);
                  },
                )
              ]),
          const Divider(
            height: 5,
          ),
          Expanded(
              child: Container(
                  child: Scrollbar(
                      controller: _scrollController,
                      isAlwaysShown: Platform.isWindows ||
                          Platform.isLinux ||
                          Platform.isMacOS,
                      child: SingleChildScrollView(
                          controller: _scrollController,
                          child: LayoutBuilder(
                              builder: (context, constraints) => ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minWidth: constraints.maxWidth),
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
                                        const DataColumn(
                                            label: Text('question')),
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
                                            label: const Text('asked'),
                                            onSort: (columnIndex, ascending) {
                                              _sort(columnIndex, ascending);
                                            }),
                                        const DataColumn(label: Text(''))
                                      ],
                                      rows: List<DataRow>.generate(
                                          filteredWords.length,
                                          (int index) => DataRow(
                                                color: MaterialStateProperty
                                                    .resolveWith<Color?>(
                                                        (Set<MaterialState>
                                                            states) {
                                                  if (states.contains(
                                                      MaterialState.selected)) {
                                                    return Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                        .withOpacity(0.08);
                                                  }
                                                  if (index.isEven) {
                                                    return Colors.grey
                                                        .withOpacity(0.1);
                                                  }
                                                  return null;
                                                }),
                                                cells: <DataCell>[
                                                  DataCell(AspectRatio(
                                                      aspectRatio: 3.0,
                                                      child: Text(filteredWords[
                                                              index]
                                                          .getInsertDateStr()))),
                                                  DataCell(SizedBox(
                                                      width: 120,
                                                      child: AspectRatio(
                                                          aspectRatio: 3.0,
                                                          child: Image.memory(
                                                              filteredWords[
                                                                      index]
                                                                  .questionPix)))),
                                                  DataCell(Text(
                                                      filteredWords[index]
                                                          .questionTxt)),
                                                  DataCell(SizedBox(
                                                      width: 120,
                                                      child: AspectRatio(
                                                          aspectRatio: 3.0,
                                                          child: Image.memory(
                                                              filteredWords[
                                                                      index]
                                                                  .answerPix)))),
                                                  DataCell(Text(
                                                      filteredWords[index]
                                                          .answerTxt)),
                                                  DataCell(Text(
                                                      "${filteredWords[index].correctCount}")),
                                                  DataCell(Text(filteredWords[
                                                          index]
                                                      .getlastAskedDateStr())),
                                                  DataCell(
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.edit),
                                                      tooltip: 'edit',
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  NewWordPage(
                                                                      editId: filteredWords[
                                                                              index]
                                                                          .id)),
                                                        ).then((value) =>
                                                            _loadWords());
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )))))))))
        ]));
  }
}
