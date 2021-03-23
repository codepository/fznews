import 'package:flutter/material.dart';

class ColumnData {
  String text;
  String key;
  // 值转换函数
  double width;
  double height;
  String Function(dynamic) formatter;
  ColumnData(this.text, this.key, {this.formatter, this.width, this.height});
  String toString() {
    return "key:$key,text:$text";
  }
}

class ResponsiveTable extends StatelessWidget {
  // 专门处理业务数据的模块
  // final ResponsiveTableBloc bloc;
  // final ScrollController scrollController;
  final Widget header;
  final List<Widget> actions;
  // 行操作
  final Widget Function(dynamic) operation;
  final List<dynamic> datas;
  final List<ColumnData> columns;
  final int rowsPerPage;
  final double columnSpacing;
  final double dataRowHeight;
  final Color backgroundColor;
  final double headingRowHeight;
  ResponsiveTable(
      {Key key,
      this.header,
      this.actions,
      this.datas,
      this.columns,
      this.columnSpacing,
      this.rowsPerPage = 10,
      this.dataRowHeight,
      this.backgroundColor,
      this.headingRowHeight,
      this.operation})
      : assert(columns != null),
        super(key: key);

  List<DataColumn> getDataColumns() {
    if (operation != null && columns[0] != null && columns[0].key != "operate") {
      columns.insert(0, ColumnData("操作", "operate"));
    }
    return this.columns.map((d) {
      return DataColumn(label: Text(d.text));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: backgroundColor,
        child: Scrollbar(
          child: PaginatedDataTable(
            header: header ?? Text("通过 header 定义表格标题"),
            actions: actions ?? <Widget>[Text("通过 actions 定义操作")],
            rowsPerPage: rowsPerPage,
            onPageChanged: (page) {},
            columns: getDataColumns(),
            columnSpacing: columnSpacing ?? 10,
            dataRowHeight: dataRowHeight ?? 75,
            headingRowHeight: headingRowHeight ?? 56,
            source: TableDataTableSource(datas, columns, context, operation: operation),
          ),
        ));
  }
}

class TableDataTableSource extends DataTableSource {
  final List<dynamic> data;
  final List<ColumnData> columns;
  final BuildContext context;
  // 行操作
  final Widget Function(dynamic) operation;
  TableDataTableSource(this.data, this.columns, this.context, {this.operation});
  List<DataCell> getDataCells(int index) {
    List<DataCell> list = List();
    columns.forEach((c) {
      switch (c.key) {
        case "operate":
          list.add(DataCell(operation(data[index])));
          break;
        case "index":
          list.add(DataCell(Text("${index + 1}")));
          break;
        default:
          list.add(DataCell(Container(
              padding: EdgeInsets.all(5),
              child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(5.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: c.width ?? 100),
                    child: Text(
                      "${c.formatter == null ? (data[index][c.key] ?? "") : c.formatter(data[index][c.key])}",
                      softWrap: true,
                      // maxLines: 5,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  )))));
      }
    });
    return list;
  }

  @override
  DataRow getRow(int index) {
    return DataRow(
      selected: true,
      cells: getDataCells(index),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
