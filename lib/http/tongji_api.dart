import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fznews/app.dart';
import 'package:fznews/http/API.dart';

class TongjiAPI {
  static Future<dynamic> getData(dynamic body) {
    // // print("查询统计数据");
    return App.request.post(API.tongjiBase + "/getData", jsonEncode(body));
  }

// getBaiduTongjiData 通过百度API获取数据
  static Future<dynamic> getBaiduTongjiData(dynamic params) {
    // // print("查询统计数据");
    return App.request.post(API.tongjiBase + "/getData", jsonEncode({"body": params}));
  }

  static Future<dynamic> download(dynamic body) {
    return App.request.download(API.tongjiBase + "/exportData", body: jsonEncode(body));
  }
}

class FlowData {
  String url;
  // 浏览量(PV)
  int pv;
  // 访客数(UV)
  int uv;
  // 贡献下游浏览量
  int outward;
  // 退出页次数
  int exit;
  // 平均停留时常
  int averageStayTime;
  FlowData(this.url, this.pv, this.uv, this.outward, this.exit, this.averageStayTime);
  static List<Map<String, dynamic>> fromResponse(dynamic data) {
    var urls = data["message"]["body"]["data"][0]["body"]["data"][0]["result"]["items"][0];
    var flows = data["message"]["body"]["data"][0]["body"]["data"][0]["result"]["items"][1];
    if (urls.length == 0) return List();
    List<Map<String, dynamic>> datas = List();
    for (int i = 0; i < urls.length; i++) {
      Map<String, dynamic> d = Map();
      d["url"] = urls[i][0]["name"];
      d["pv"] = flows[i][0];
      d["uv"] = flows[i][1];
      d["outward"] = flows[i][2];
      d["exit"] = flows[i][3];
      d["averageStayTime"] = flows[i][4];
      datas.add(d);
    }
    return datas;
  }
}
