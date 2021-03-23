import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/http/response_data.dart';
import 'package:fznews/http/yxkh_api.dart';
import 'package:fznews/widget/icon_button_countdown.dart';
import 'package:fznews/widget/table.dart';

class MarksTableWidget extends StatefulWidget {
  final Map<String, dynamic> params;
  final List<ColumnData> column;
  MarksTableWidget({this.params, this.column});
  @override
  State<StatefulWidget> createState() {
    return _MarksTableWidgetState();
  }
}

class _MarksTableWidgetState extends State<MarksTableWidget> {
  List<dynamic> _data;
  Map<String, dynamic> _params;
  List<ColumnData> _column;
  Widget _header;
  TextEditingController startTec;
  TextEditingController endTec;
  @override
  void dispose() {
    super.dispose();
    startTec.dispose();
    endTec.dispose();
  }

  @override
  void initState() {
    super.initState();
    _params = widget.params ?? Map();
    startTec = TextEditingController(text: _params["startDate"] ?? "");
    endTec = TextEditingController(text: _params["endDate"] ?? "");
    _column = widget.column ??
        <ColumnData>[
          // ColumnData("操作", "operate", width: 20),
          ColumnData(
            "开始日期",
            "startDate",
            width: 80,
            formatter: (val) {
              return val.substring(0, 10);
            },
          ),
          ColumnData("评分", "markNumber"),
          ColumnData("评分原因", "markReason", width: 150),
          ColumnData("评分依据", "accordingly", width: 150),
          ColumnData(
            "结束日期",
            "endDate",
            width: 80,
            formatter: (val) {
              return val.substring(0, 10);
            },
          ),
        ];
    _data = List();
    this.findDatas();
    _header = Row(
      children: <Widget>[
        Container(
          width: 100,
          child: TextField(
            decoration: InputDecoration(hintText: "开始日期:2020-01-01"),
            controller: startTec,
            onChanged: (value) {},
          ),
        ),
        Container(
          width: 100,
          child: TextField(
            decoration: InputDecoration(hintText: "结束日期:2020-01-01"),
            controller: endTec,
            onChanged: (value) {},
          ),
        ),
        IconButtonCountDown(
          seconds: 10,
          iconSize: 30,
          color: Colors.green,
          icon: Icon(Icons.search),
          onPressed: () {
            _params["startDate"] = startTec.text;
            _params["endDate"] = endTec.text;
            this.findDatas();
          },
        ),
      ],
    );
  }

  void findDatas() {
    YXKHAPI.findAllMarks(_params).then((data) {
      if (data["status"] != 200) {
        App.showAlertError(context, data["message"]);
        return;
      }
      var datas = ResponseData.fromResponse(data);
      _data = datas[0];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      child: SingleChildScrollView(
        child: ResponsiveTable(
          actions: <Widget>[],
          header: _header,
          datas: _data,
          columns: _column,
          rowsPerPage: 5,
          backgroundColor: Colors.grey[100],
          operation: (value) {
            return PopupMenuButton(
              tooltip: "点击操作",
              onSelected: (val) {
                switch (val) {
                  case "删除申请":
                    break;
                  case "修改申请":
                    break;
                  default:
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "删除申请",
                  child: ListTile(
                    leading: Icon(Icons.delete_forever),
                    title: Text("删除申请"),
                  ),
                ),
                PopupMenuItem(
                  value: "修改申请",
                  child: ListTile(
                    leading: Icon(Icons.refresh),
                    title: Text("修改申请"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
