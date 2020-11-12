import 'dart:convert';

import 'package:fznews/app.dart';
import 'package:fznews/http/API.dart';

class TongjiAPI{
  static Future<dynamic> getData(dynamic body) {
    // // print("查询统计数据");
    return App.request.post(API.tongjiBase+"/getData",jsonEncode(body));
  }
  static Future<dynamic> download(dynamic body){
    return App.request.download(API.tongjiBase+"/exportData",jsonEncode(body));
  }
}