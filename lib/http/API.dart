import 'package:fznews/app.dart';
class API {
  // 查询统计数据接口
  static String tongjiBase = App.baiduTongjiAPI;
  static String userBase = App.userAPI;
  static  String yxkhBase = App.config["API"]["yxkh"];
  // =============== 字典 ====================
  static String findAllInfoDic = yxkhBase+'/infodic/findAll';

}