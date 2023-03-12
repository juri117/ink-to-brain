import 'package:flutter/material.dart';
import 'package:ink2brain/database_con.dart';
import 'package:ink2brain/models/word.dart';
import 'package:ink2brain/new_words.dart';
import 'package:ink2brain/widgets/table_page.dart';

const String TAG = "fleet_overview_page";

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);
  @override
  ListPageState createState() => ListPageState();
}

class ListPageState extends State<ListPage> {
  WordTableRow tableRow = WordTableRow([], null, null);
  int _sortColumnIndex = 0;
  bool _sortAscending = false;
  Comparable<dynamic> Function(Word d) prevSort = (Word d) => d.insertTs;
  final TextEditingController _searchTxtControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    List<Word> newWords = await DatabaseCon().words(orderBy: "insertTs");
    setState(() {
      //newWords.shuffle();
      tableRow = WordTableRow(newWords, _resetWordScore, _editWord);
      tableRow._filter(_searchTxtControl.text);
      tableRow._sort(prevSort, _sortAscending);
    });
  }

  Future<void> _resetWordScore(Word word) async {
    await DatabaseCon().resetWordScore(word);
    _loadWords();
    //setState(() {
    //  word.correctCount = 0;
    //});
  }

  void _sort<T>(Comparable<T> Function(Word d) getField, int columnIndex,
      bool ascending) {
    prevSort = getField;
    tableRow._sort<T>(getField, ascending);
    if (!mounted) return;
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  void _editWord(Word word) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewWordPage(editId: word.id)),
    ).then((value) => _loadWords());
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
        body: TablePage(
            //Text("Questions"),
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
                            tableRow._filter(_searchTxtControl.text);
                            tableRow._sort(prevSort, _sortAscending);
                            //_filterWords(searchWord: _searchTxtControl.text);
                          },
                          minLines: 1, //Normal textInputField will be displayed
                          maxLines:
                              1, // when user presses enter it will adapt to it
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                            hintText: '...',
                            labelText: 'search',
                            suffixIcon: IconButton(
                              // Icon to
                              icon: const Icon(Icons.clear,
                                  color: Colors.grey), // clear text
                              onPressed: () {
                                setState(() {
                                  _searchTxtControl.text = "";
                                });
                                tableRow._filter("");
                                tableRow._sort(prevSort, _sortAscending);
                              },
                            ),
                          ))),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    child: const Text("search"),
                    onPressed: () {
                      tableRow._filter(_searchTxtControl.text);
                      tableRow._sort(prevSort, _sortAscending);
                    },
                  )
                ]),
            <DataColumn>[
              DataColumn(
                label: const Text('added'),
                onSort: (int columnIndex, bool ascending) => _sort<DateTime>(
                    (Word d) => d.insertTs, columnIndex, ascending),
              ),
              const DataColumn(label: Text('question')),
              DataColumn(
                label: const Text(''),
                onSort: (int columnIndex, bool ascending) => _sort<String>(
                    (Word d) => d.questionTxt, columnIndex, ascending),
              ),
              const DataColumn(label: Text('answer')),
              DataColumn(
                label: const Text(''),
                onSort: (int columnIndex, bool ascending) => _sort<String>(
                    (Word d) => d.answerTxt, columnIndex, ascending),
              ),
              DataColumn(
                label: const Text('correct'),
                onSort: (int columnIndex, bool ascending) => _sort<num>(
                    (Word d) => d.correctCount, columnIndex, ascending),
              ),
              DataColumn(
                label: const Text('asked'),
                onSort: (int columnIndex, bool ascending) => _sort<DateTime>(
                    (Word d) =>
                        d.lastAskedTs ?? DateTime.fromMicrosecondsSinceEpoch(0),
                    columnIndex,
                    ascending),
              ),
              const DataColumn(label: Text(''))
            ],
            tableRow,
            _loadWords,
            _sortColumnIndex,
            _sortAscending));
  }
}

class WordTableRow extends DataTableSource {
  final List<Word> data;
  List<Word> filteredData = [];
  final Function? resetWordScore;
  final Function? editWord;

  WordTableRow(this.data, this.resetWordScore, this.editWord) {
    filteredData = data;
  }

  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(index: index, cells: [
      DataCell(AspectRatio(
          aspectRatio: 3.0,
          child: Text(filteredData[index].getInsertDateStr()))),
      DataCell(SizedBox(
          width: 120,
          child: (filteredData[index].questionPix.isNotEmpty)
              ? AspectRatio(
                  aspectRatio: 3.0,
                  child: Image.memory(filteredData[index].questionPix))
              : const Text(""))),
      DataCell(Text(filteredData[index].questionTxt)),
      DataCell(SizedBox(
          width: 120,
          child: (filteredData[index].answerPix.isNotEmpty)
              ? AspectRatio(
                  aspectRatio: 3.0,
                  child: Image.memory(filteredData[index].answerPix))
              : const Text(""))),
      DataCell(Text(filteredData[index].answerTxt)),
      DataCell(Text("${filteredData[index].correctCount}")),
      DataCell(Text(filteredData[index].getLastAskedDateStr())),
      DataCell(Row(children: [
        IconButton(
          icon: const Icon(Icons.restore_page_outlined),
          tooltip: 'reset score',
          onPressed: () {
            if (resetWordScore != null) {
              resetWordScore!(filteredData[index]);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          tooltip: 'edit',
          onPressed: () {
            if (editWord != null) {
              editWord!(filteredData[index]);
            }
          },
        ),
      ]))
    ]);
  }

  void _sort<T>(Comparable<T> Function(Word d) getField, bool ascending) {
    filteredData.sort((Word a, Word b) {
      if (!ascending) {
        final Word c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  void _filter(String searchTxt) {
    if (searchTxt == "") {
      filteredData = data;
      return;
    }
    filteredData = data
        .where((w) =>
            w.questionTxt.toLowerCase().contains(searchTxt.toLowerCase()) ||
            w.answerTxt.toLowerCase().contains(searchTxt.toLowerCase()))
        .toList();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredData.length;

  @override
  int get selectedRowCount => 0;
}
