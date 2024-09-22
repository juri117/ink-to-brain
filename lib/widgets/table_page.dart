import 'package:flutter/material.dart';

const String tag = "TablePage";

class TablePage extends StatefulWidget {
  final Widget title;
  final List<DataColumn> columns;
  final DataTableSource tableRow;
  final Function refresh;
  final int sortIndex;
  final bool sortAsc;
  const TablePage(this.title, this.columns, this.tableRow, this.refresh,
      this.sortIndex, this.sortAsc,
      {Key? key})
      : super(key: key);
  @override
  TablePageState createState() => TablePageState();
}

class TablePageState extends State<TablePage> {
  int rowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: (widget.tableRow.rowCount <= 0)
            ? Center(
                child: Column(children: [
                const Text("loading..."),
                const SizedBox(height: 10),
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.tertiary,
                )
              ]))
            : SizedBox(
                width: double.infinity,
                child: PaginatedDataTable(
                  header: widget.title,
                  actions: [
                    Tooltip(
                        message: "reload",
                        waitDuration: const Duration(seconds: 1),
                        child: ElevatedButton(
                          child: const Icon(Icons.refresh),
                          onPressed: () {
                            widget.refresh();
                          },
                        ))
                  ],
                  onRowsPerPageChanged: (perPage) {
                    setState(() {
                      rowsPerPage = perPage ?? 10;
                    });
                  },
                  rowsPerPage: rowsPerPage,
                  columns: widget.columns,
                  source: widget.tableRow,
                  sortColumnIndex: widget.sortIndex,
                  sortAscending: widget.sortAsc,
                )),
      ),
    );
  }
}
