import 'package:flutter/material.dart';
import 'package:fznews/http/response_data.dart';
import 'package:fznews/http/yxkh_api.dart';
import 'package:fznews/widget/icon_button_countdown.dart';
import 'package:fznews/widget/select.dart';

import 'package:fznews/widget/table.dart';
import 'package:fznews/yxkh/marks_table.dart';

import '../app.dart';

// MarksRankTable 加减分排行表格
class MarksRankTable extends StatefulWidget {
  final Map<String, dynamic> params;
  final List<ColumnData> column;
  MarksRankTable({this.params, this.column});
  @override
  State<StatefulWidget> createState() {
    return _MarksRankTableState();
  }
}

class _MarksRankTableState extends State<MarksRankTable> {
  List<dynamic> _data;
  Map<String, dynamic> _params;
  List<ColumnData> _column;
  Widget _header;
  TextEditingController startTec;
  TextEditingController endTec;
  TextEditingController usernameTec;
  @override
  void dispose() {
    super.dispose();
    startTec.dispose();
    endTec.dispose();
    usernameTec.dispose();
  }

  @override
  void initState() {
    super.initState();
    _params = widget.params ?? Map();
    startTec = TextEditingController(text: _params["startDate"] ?? "");
    endTec = TextEditingController(text: _params["endDate"] ?? "");
    usernameTec = TextEditingController(text: _params["username"] ?? "");
    _column = widget.column ??
        <ColumnData>[
          ColumnData("姓名", "username"),
          ColumnData("总分", "markNumber"),
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
        Container(
          width: 80,
          child: TextField(
            decoration: InputDecoration(hintText: "用户姓名"),
            controller: usernameTec,
            onChanged: (value) {},
          ),
        ),
        IconButtonCountDown(
          seconds: 3,
          iconSize: 30,
          color: Colors.green,
          icon: Icon(Icons.search),
          onPressed: () {
            _params["startDate"] = startTec.text;
            _params["endDate"] = endTec.text;
            _params["username"] = usernameTec.text;
            this.findDatas();
          },
        ),
      ],
    );
  }

  void findDatas() {
    YXKHAPI.findMarksRank(_params).then((data) {
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
      width: 374,
      child: SingleChildScrollView(
        child: ResponsiveTable(
          actions: <Widget>[],
          header: _header,
          datas: _data,
          columns: _column,
          rowsPerPage: 5,
          dataRowHeight: 50,
          operation: (data) {
            return PopupMenuButton(
              tooltip: "点击操作",
              onSelected: (val) {
                switch (val) {
                  case "加减分明细":
                    App.showAlertDialog(
                        context,
                        Text("加减分明细"),
                        MarksTableWidget(params: {
                          "userId": data["userId"],
                          "startDate": _params["startDate"],
                          "endDate": _params["endDate"]
                        }));
                    break;
                  default:
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "加减分明细",
                  child: ListTile(
                    leading: Icon(Icons.remove_red_eye),
                    title: Text("加减分明细"),
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
