import 'dart:convert';

import 'package:fznews/app.dart';
import 'package:fznews/http/API.dart';

class  YXKHAPI {
  static  String base = API.yxkhBase;
  static Future<dynamic> selectHistoryTotalMark(dynamic body) {
    // // print("查询统计数据");
    return App.request.post(base+"/selectHistoryTotalMark/month",jsonEncode(body));
  }
}