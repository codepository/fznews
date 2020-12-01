import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fznews/fluro_router.dart';
import 'package:fznews/http/http_request.dart';
import 'package:fznews/http/user_api.dart';
import 'package:fznews/routes.dart';
import 'package:fznews/tongji/model/tongji_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum ENV {
  PRODUCTION,
  DEV,
}

class App {
  static const String ASSEST_IMG = 'assets/images/';
  static Map<String, dynamic> config;
  static FluroRouter router;
  static HttpRequest request;
  static String baiduTongjiAPI;
  static String userAPI;
  static Userinfos userinfos;
  static SharedPreferences sharedPreferences;
  // 站点列表
  static List<dynamic> sitelist;
  // 加载配置
  static Future<String> getConf() async {
    return await rootBundle.loadString('config/config.json');
  }

  static Future<void> loadConf(String val) async {
    App.config = json.decode(val);
    // http连接
    request = HttpRequest(http.Client());
    // 变量

    baiduTongjiAPI = App.config["API"]["tongji"];
    userAPI = App.config["API"]["user"];
    //
    sharedPreferences = await SharedPreferences.getInstance();
    // 加载用户信息
    userinfos = Userinfos();

    await getUserByToken();

    Routes.setRouters();
    // 路由
    App.router = FluroRouter();

    return;
  }

  static Future<void> getUserByToken() async {
    var token = getToken();

    if (token == null) {
      return;
    }
    print('初始化并查询用户数据token:$token');
    var data = await UserAPI.getUserInfoByToken(token);
    if (data["status"] == 200) {
      Tongji tj = Tongji.fromJson(data['message']);
      App.userinfos = Userinfos.fromTongji(tj);
    }
    return;
  }

  static String getToken() {
    return sharedPreferences.getString("token");
  }

  static void setToken(String token) {
    App.userinfos.token = token;
    sharedPreferences.setString("token", token);
  }

  static void showAlertError(BuildContext context, String msg) {
    showAlertDialog(context, Text('错误'), Text(msg));
  }

  static void showAlertInfo(BuildContext context, String msg) {
    showAlertDialog(context, Text('消息'), Text(msg));
  }

  // showAlertDialog 弹出全局对话框
  static void showAlertDialog(BuildContext context, Widget title, Widget content, {var callback}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (callback != null) callback();
            },
            child: Text('确认'),
          ),
          FlatButton(
            color: Colors.grey,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("取消"),
          ),
        ],
      ),
    );
  }

  static dispose() {
    // print("=====关闭http连接=====");
    request.client.close();
  }
}
