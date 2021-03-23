import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/http/yxkh_api.dart';
import 'package:fznews/widget/button_countdown.dart';
import 'package:fznews/widget/icon_button_countdown.dart';
import 'package:fznews/widget/select.dart';
import 'package:fznews/widget/table.dart';
import 'package:fznews/yxkh/bloc/homepageBloc.dart';

// YxkhYearRanksWidget 一线考核年度排行
class YxkhYearRanksWidget extends StatelessWidget {
  final HomePageBlocImpl bloc;
  final TextEditingController yearTec = TextEditingController();
  final TextEditingController typeTec = TextEditingController();
  final TextEditingController tagsTec = TextEditingController();
  YxkhYearRanksWidget({this.bloc}) : assert(bloc != null);
  @override
  Widget build(BuildContext context) {
    var sparation = bloc.fullyearRankParams["sparation"].split("-");
    typeTec.text = sparation[1];
    yearTec.text = sparation[0].substring(0, 4);
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
                child: Text("半年考评排行",
                    style: TextStyle(fontSize: 22, color: Colors.blue[800], fontWeight: FontWeight.bold)),
              ),
              Container(
                height: 20,
                width: 5,
                color: Colors.blue[400],
                margin: EdgeInsets.only(right: 5),
              ),
              Container(
                margin: EdgeInsets.only(right: 5),
                child: Text(
                  "年考评排行",
                  style: TextStyle(fontSize: 22, color: Colors.blue[800], fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: SingleChildScrollView(
            child: StreamBuilder<List<dynamic>>(
              stream: bloc.fullyearRankStream,
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
                    columns: <ColumnData>[
                      ColumnData("序号", "index"),
                      ColumnData("用户姓名", "username"),
                      ColumnData("类型", "sparation", width: 120),
                      ColumnData("考效总分", "marks"),
                      ColumnData("群众评议", "publicEvaluation"),
                      ColumnData("领导点评", "leadershipEvaluation"),
                      ColumnData("组织考核", "organizationEvaluation"),
                      ColumnData("总分", "totalMark"),
                      ColumnData("考核结果", "result"),
                    ],
                    rowsPerPage: data.length > 10 ? 10 : data.length,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 100,
          child: Select(
            textEditingController: yearTec,
            items: _buildYear(),
            hintText: "选择年份",
            valueTag: "value",
            onChange: (key, val) {
              yearTec.text = val;
              bloc.fullyearRankParams["sparation"] = "${val ?? ""}年-${typeTec.text ?? ""}";
              bloc.onSearchFullyearRank();
            },
          ),
        ),
        Container(
          width: 100,
          child: Select(
            textEditingController: typeTec,
            items: [
              {"key": "半年考核", "value": "半年考核"},
              {"key": "年度考核", "value": "年度考核"}
            ],
            hintText: "选择类型",
            valueTag: "value",
            onChange: (key, val) {
              typeTec.text = val;
              bloc.fullyearRankParams["sparation"] = "${yearTec.text ?? ""}年-${val ?? ""}";
              bloc.onSearchFullyearRank();
            },
          ),
        ),
        Container(
          width: 200,
          child: StreamBuilder<List<dynamic>>(
            stream: bloc.groupsStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else if (snapshot.data.isEmpty) {
                var datas = bloc.groups ?? List();
                return Select(
                  textEditingController: tagsTec,
                  hintText: "选择考核组",
                  items: datas,
                  valueTag: "value",
                  onChange: (key, val) {
                    tagsTec.text = val;
                    tagsTec.text = bloc.fullyearRankParams["tags"] = tagsTec.text;
                    bloc.onSearchFullyearRank();
                  },
                );
              }
              return Select(
                textEditingController: tagsTec,
                hintText: "选择考核组",
                items: snapshot.data,
                valueTag: "value",
                onChange: (key, val) {
                  tagsTec.text = val;
                  tagsTec.text = bloc.fullyearRankParams["tags"] = tagsTec.text;
                  bloc.onSearchFullyearRank();
                },
              );
            },
          ),
        ),
        IconButtonCountDown(
          icon: Icon(Icons.refresh),
          iconSize: 30,
          color: Colors.green,
          onPressed: () {
            bloc.onSearchFullyearRank();
          },
        ),
        ButtonCountDown(
          elevation: 0,
          child: Text("导出Excel"),
          color: Colors.blue,
          onPressed: () {
            if (App.hasAuthority(context, "考核组考核员")) {
              YXKHAPI.exportAllEvaluationRank(bloc.fullyearRankParams);
            }
          },
        )
      ],
    );
  }

  List<dynamic> _buildYear() {
    var now = DateTime.now();
    List<dynamic> datas = List();
    int year = now.year;
    int i = 1;
    while (i < 20) {
      datas.add({"key": "$year", "value": "$year"});
      i++;
      year--;
    }
    return datas;
  }
}
