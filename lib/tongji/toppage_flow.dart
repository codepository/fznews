import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fznews/http/tongji_api.dart';
import 'package:fznews/tongji/widget/SearchToppageWidget.dart';
import 'package:fznews/widget/icon_button_countdown.dart';
import 'package:fznews/widget/table.dart';

import '../app.dart';

class ToppageFlow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ToppageFlowState();
  }
}

class _ToppageFlowState extends State<ToppageFlow> {
  Map<String, dynamic> params = Map();
  List<dynamic> datas = List();
  // 站点列表
  List<dynamic> sitelist;
  List<dynamic> flag;
  List<Widget> _actions;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    params["method"] = "visit/flow/findAllRealTimeFlow";
    this.getSitelist();
    _actions = <Widget>[
      IconButtonCountDown(
        icon: Icon(Icons.refresh),
        iconSize: 50,
        color: Colors.blue,
        tooltip: "刷新",
        onPressed: () {
          search(params);
        },
      ),
      IconButton(
        icon: Icon(Icons.search),
        iconSize: 50,
        color: Colors.blue,
        tooltip: "搜索",
        onPressed: () {
          App.showAlertDialog(
              context,
              Text("搜索"),
              SearchToppageWidget(
                params: params,
                sitelist: jsonDecode(App.sharedPreferences.getString("sitelist") ?? []),
              ), callback: () {
            search(params);
          });
        },
      ),
    ];
  }

  void getSitelist() {
    // sitelist = jsonDecode(App.sharedPreferences.getString("sitelist"));
    // if (sitelist != null) {
    //   return;
    // }
    TongjiAPI.getBaiduTongjiData({"method": "visit/flow/sitelist"}).then((data) {
      if (data["status"] != 200) {
        App.showAlertError(context, data["message"]);
        return;
      }
      setState(() {
        this.sitelist = data["message"]["body"]["data"][0];
        App.sharedPreferences.setString("sitelist", jsonEncode(sitelist));
      });
    });
  }

  void search(Map<String, dynamic> params) {
    if (params["siteID"] == null) {
      App.showAlertError(context, "站点不能为空");
      return;
    }
    TongjiAPI.getBaiduTongjiData(params).then((data) {
      if (data["status"] != 200) {
        App.showAlertError(context, data["message"]);
        return;
      }
      datas = FlowData.fromResponse(data);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveTable(
        datas: datas,
        actions: <Widget>[],
        header: Row(
          children: _actions,
        ),
        columns: <ColumnData>[
          ColumnData("页面浏览量", "url"),
          ColumnData("浏览量(PV)", "pv"),
          ColumnData("访客数(UV)", "uv"),
          ColumnData("贡献下游浏览量", "outward"),
          ColumnData("退出页次数", "exit"),
          ColumnData("平均停留时常", "averageStayTime"),
        ],
      ),
    );
  }
}
