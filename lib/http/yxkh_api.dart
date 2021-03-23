import 'dart:convert';

import 'package:fznews/app.dart';
import 'package:fznews/http/API.dart';

class YXKHAPI {
  static String base = API.yxkhBase;
  static Future<dynamic> selectHistoryTotalMark(dynamic body) {
    // // print("查询统计数据");
    return App.request.post(base + "/selectHistoryTotalMark/month", jsonEncode(body));
  }

  // 一线考核首页内容
  static Future<dynamic> findYXKHHomedata({bool refresh = false}) {
    if (refresh) {
      return App.request.post(
          base + "/getData",
          jsonEncode({
            "body": {"method": "visit/yxkh/refreshhomedata"}
          }));
    }
    return App.request.post(
        base + "/getData",
        jsonEncode({
          "body": {"method": "visit/yxkh/homedata"}
        }));
  }

  // findAllMarks 查询加减分
  // 参数格式:{"body":{"params":{"offset":0,"limit":20,"fields":"markId,userId,username,markReason,markNumber,accordingly","markId":1,"projectId":3,"markReason":"加分原因","accordingly":"加分依据的规则","startDate":"2020-04-03","endDate":"2020-05-06","userId":19,"username":"用户名","checked":"1"}}} ，checked为字符串：1-已生效、0-未生效
  static Future<dynamic> findAllMarks(Map<String, dynamic> params) {
    return App.request.post(
        base + "/getData",
        jsonEncode({
          "body": {"method": "visit/yxkh/findallMarks", "params": params}
        }));
  }

  // findMarksRank 查询加减分排行
  // 参数格式:{"body":{"params":{"limit":50,"offset":0,"startDate":"2020-01-01","endDate":"2020-01-02","username":"用户姓名","group":"第一考核组成员,第二考核组成员","tags":"项目舞台,系统管理员","level":"0,1,2"}}} group 表示考核组 tags 表示用户标签，level表示用户职级：0-普通员工，1-中层副职,2-中层正职
  static Future<dynamic> findMarksRank(Map<String, dynamic> params) {
    return App.request.post(
        base + "/getData",
        jsonEncode({
          "body": {"method": "visit/yxkh/findMarksRank", "params": params}
        }));
  }

  // findAllEvalutionRank 半年和年度考核排行
  static Future<dynamic> findAllEvalutionRank(Map<String, dynamic> params) {
    return App.request.post(
        base + "/getData",
        jsonEncode({
          "body": {"method": "visit/yxkh/findAllEvalutionRank", "params": params}
        }));
  }

  static Future<dynamic> exportAllEvaluationRank(Map<String, dynamic> params) {
    return App.request.download(base + "/export",
        body: jsonEncode({
          "body": {
            "method": "export/yxkh/findAllEvalutionRank",
            "params": params,
            "data": [
              ["用户名", "部门", "考效总分", "领导点评", "群众评议", "组织考评", "总分", "考核结果"],
              [
                "username",
                "department",
                "marks",
                "leadershipEvaluation",
                "publicEvaluation",
                "organizationEvaluation",
                "totalMark",
                "result"
              ]
            ]
          }
        }));
  }

  // getYearAssessType 返回年度考核或者半年考核，值与数据库表res_evaluation 中的sparation 字段对应
  static String getYearAssessType() {
    var now = DateTime.now();
    if (now.month > 6) {
      return "${now.year}年-半年考核";
    } else {
      return "${now.year - 1}年-年度考核";
    }
  }

  // *************************** 字典查询 *****************************
  // findAllDict 从info_dic表查询信息
  // {"body":"params":{"name":"评分依据","value":"","type":"","type2"}}
  static Future<dynamic> findAllDict(Map<String, dynamic> params) {
    return App.request.post(
        base + "/getData",
        jsonEncode({
          "body": {"method": "visit/yxkh/findDict", "params": params}
        }));
  }

// delDict 删除字典
  static Future<dynamic> delDict(int id) {
    return App.request.post(
        base + "/getData",
        jsonEncode({
          "body": {
            "method": "exec/yxkh/delDict",
            "params": {
              "data": [id]
            }
          }
        }));
  }

  // 修改字典
  static Future<dynamic> updateDict(Map<String, dynamic> params) {
    return App.request.post(
        base + "/getData",
        jsonEncode({
          "body": {
            "method": "exec/yxkh/updateDict",
            "params": {
              "data": [params]
            }
          }
        }));
  }

// exportMarksPriciple 导出加减分评分依据
  static Future<dynamic> exportMarksPriciple() {
    return App.request.download(base + "/export",
        body: jsonEncode({
          "body": {
            "method": "export/yxkh/exportMarksPriciple",
            "data": [
              ["序号", "修改前", "修改后"],
              ["ID", "value"]
            ]
          }
        }));
  }

// importMarksPriciple 导入加减分评分依据
  static Future<dynamic> importMarksPriciple() {
    return App.request.upload(uri: base + "/import", method: "import/yxkh/importMarksPriciple", token: App.getToken());
  }
}
