import 'package:flutter/material.dart';
import 'package:fznews/widget/icon_button_countdown.dart';
import 'package:fznews/widget/table.dart';
import 'package:fznews/yxkh/bloc/YxkhMarksPrincipleBloc.dart';

import '../../app.dart';
import 'AutoDeductSettingWidget.dart';

class YxkhMarksPrincipleWidget extends StatelessWidget {
  final YxkhMarksPrincipleBlocImpl bloc;
  final double width;
  YxkhMarksPrincipleWidget({@required this.bloc, this.width});
  Widget _buildHeader(BuildContext context) {
    TextEditingController tec = TextEditingController();
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          child: TextField(
            decoration: InputDecoration(hintText: "加分明细"),
            controller: tec,
            onChanged: (value) {},
          ),
        ),
        IconButtonCountDown(
          icon: Icon(Icons.search),
          iconSize: 30,
          color: Colors.green,
          onPressed: () {
            bloc.params["value"] = tec.text;
            bloc.onSearch();
          },
        ),
        IconButtonCountDown(
          icon: Icon(Icons.file_download),
          iconSize: 30,
          color: Colors.blue,
          tooltip: "批量导出",
          onPressed: () {
            bloc.exportMarksPriciple();
          },
        ),
        IconButtonCountDown(
          icon: Icon(Icons.file_upload),
          iconSize: 30,
          color: Colors.blueGrey,
          tooltip: "批量修改",
          onPressed: () {
            if (App.hasAuthority(context, "考核办")) {
              bloc.importMarksPriciple().then((data) {
                App.showAlertInfo(context, data);
              });
            }
          },
        ),
        MaterialButton(
          child: Text("设置"),
          color: Colors.blue,
          onPressed: () {
            if (App.hasAuthority(context, "考核办")) {
              App.showAlertDialog(
                context,
                Text("设置"),
                AutoDeductSettingWidget(),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: Colors.grey))),
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                Container(
                  height: 20,
                  width: 12,
                  color: Colors.blue[400],
                  margin: EdgeInsets.only(right: 5),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Text("加减分细则",
                      style: TextStyle(fontSize: 22, color: Colors.blue[800], fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Container(
            child: SingleChildScrollView(
              child: StreamBuilder<List<dynamic>>(
                stream: bloc.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data.isEmpty) {
                    return Center(
                      child: _buildHeader(context),
                    );
                  }
                  var data = snapshot.data;
                  return Scrollbar(
                    child: ResponsiveTable(
                      actions: <Widget>[],
                      header: _buildHeader(context),
                      datas: data,
                      dataRowHeight: 100,
                      rowsPerPage: 2,
                      operation: (data) {
                        return PopupMenuButton(
                          tooltip: "点击操作",
                          onSelected: (val) {
                            switch (val) {
                              case "删除":
                                // 判断权限,考核办才能删除
                                if (App.hasAuthority(context, "考核办")) {
                                  // 删除确认
                                  var check = "";
                                  App.showAlertDialog(
                                      context,
                                      Text("删除确认"),
                                      Container(
                                        child: TextField(
                                          decoration: InputDecoration(hintText: "如果确定要删除请输入: 54687"),
                                          onChanged: (value) => check = value,
                                        ),
                                      ), callback: () {
                                    if (check == "54687") {
                                      bloc.onDel(data["ID"]).then((data) {
                                        App.showAlertInfo(context, data);
                                      });
                                    }
                                  });
                                }

                                // 删除
                                break;
                              default:
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: "删除",
                              child: ListTile(
                                leading: Icon(Icons.delete_forever),
                                title: Text("删除"),
                              ),
                            ),
                          ],
                        );
                      },
                      columns: <ColumnData>[
                        ColumnData("项目", "value", width: width),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
