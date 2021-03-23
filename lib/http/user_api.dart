import 'dart:convert';
import 'package:fznews/app.dart';
import 'package:fznews/http/API.dart';
import 'package:fznews/tongji/model/tongji_model.dart';

class UserAPI {
  static Future<dynamic> getData(dynamic body) {
    return App.request.post(API.userBase + "/getData", jsonEncode(body));
  }

  // 获取所有用户
  static Future<dynamic> getUsers({String username}) {
    return App.request.post(
        API.userBase + "/getData",
        jsonEncode({
          "body": {"method": "visit/user/getUsers", "username": username}
        }));
  }

  // 获取所有标签
  static Future<dynamic> getAllLabels() {
    return App.request.post(
        API.userBase + "/getData",
        jsonEncode({
          "body": {"method": "visit/lable/all"}
        }));
  }

  // 获取所有部门
  static Future<dynamic> getAllDepartments({bool paged = false, bool refresh = false}) {
    return App.request.post(
        API.userBase + "/getData",
        jsonEncode({
          "body": {"refresh": refresh, "paged": paged, "method": "visit/department/all"}
        }));
  }

  // 更新部门
  static Future<dynamic> updateDepartment(int id, {int attribute}) {
    return App.request.post(
        API.userBase + "/getData",
        jsonEncode({
          "body": {
            "method": "exec/department/update",
            "params": {
              "data": [
                {"id": id, "attribute": attribute}
              ]
            }
          }
        }));
  }

  // 根据部门添加标签
  static Future<dynamic> addLabelByDepartments(int labelid, List<dynamic> departmentIds) {
    return App.request.post(
        API.userBase + "/getData",
        jsonEncode({
          "header": {"token": App.getToken()},
          "body": {
            "method": "exec/user/addlabelbyDepartment",
            "data": [
              [labelid],
              departmentIds
            ]
          }
        }));
  }

  // 根据部门添加标签
  static Future<dynamic> addLabel(String labelname, labeltype, describe) {
    return App.request.post(
        API.userBase + "/getData",
        jsonEncode({
          "header": {"token": App.getToken()},
          "body": {
            "method": "exec/label/add",
            "data": [
              {"name": labelname, "type": labeltype, "describe": describe}
            ]
          }
        }));
  }

  // 登陆
  static Future<dynamic> login(dynamic params) {
    return App.request.post(API.userBase + "/login", jsonEncode(params));
  }

  // 获取token获取用户信息
  static Future<dynamic> getUserInfoByToken(String token) {
    return App.request.post(
        API.userBase + "/getData",
        jsonEncode({
          "header": {"token": token},
          "body": {"method": "visit/user/userinfoByToken"}
        }));
  }

  // 修改用户密码
  static Future<dynamic> alterPassword(String token, password) {
    return App.request.post(
        API.userBase + "/getData",
        jsonEncode({
          "header": {"token": token},
          "body": {"method": "exec/user/alterPass", "metrics": password}
        }));
  }

  // 用户分管部门
  static Future<dynamic> getLeadership({int userid, int departmentid, String departmentname}) {
    return App.request.post(
        API.userBase + "/getData",
        jsonEncode({
          "body": {
            "method": "visit/leader/find",
            "params": {"user_id": userid, "department_id": departmentid, "department_name": departmentname}
          }
        }));
  }

  static Future<dynamic> delLeadership(List<int> ids) {
    return App.request.post(
        API.userBase + "/getData",
        jsonEncode({
          "header": {"token": App.getToken()},
          "body": {
            "method": "exec/leader/delbyid",
            "data": [ids]
          }
        }));
  }

  static Future<dynamic> addLeadership(List<dynamic> departments, String userid, {int role}) {
    return App.request.post(
        API.userBase + "/getData",
        jsonEncode({
          "header": {"token": App.getToken()},
          "body": {
            "method": "exec/leader/add",
            // role=6表示是分管领导,role=5表示是部门领导
            "params": {"role": role ?? 6, "userid": userid},
            "data": [departments]
          }
        }));
  }

  // syncLeadership 同步分管部门信息
  static Future<dynamic> syncLeadership() {
    return App.request.post(
        API.userBase + "/getData",
        jsonEncode({
          "header": {"token": App.getToken()},
          "body": {"method": "exec/department/sync"}
        }));
  }

// ************************** 流程相关 ******************************************
// 查询未提交XX流程的用户清单（分考核组）
// personUnApplyByGroup
  static Future<dynamic> personUnApplyByGroup({int limit, int apply, String titleLike}) {
    return App.request.post(
        API.userBase + "/getData",
        jsonEncode({
          "body": {
            "method": "visit/task/personApplyYxkh",
            "params": {
              "limit": limit,
              // 0 表示未提交，1表示已提交
              "apply": apply,
              // 流程名称模糊查询
              "titleLike": titleLike
            }
          }
        }));
  }

// ************************** 文件上传与下载 ************************************
// 查询上传文件
  static Future<dynamic> findUploadfiles({String fields, String filetype, String filename, int limit, int offset}) {
    // print("findUploadfiles,查询文件");
    return App.request.post(
        API.userBase + "/getData",
        jsonEncode({
          "body": {
            "method": "visit/uploadfile/find",
            "params": {"fields": fields, "filetype": filetype, "filename": filename, "limit": limit, "offset": offset}
          }
        }));
  }

// saveFileToDB 将文件上传至数据库
  static Future<dynamic> saveFileToDB(String filetype) {
    return App.request.upload(uri: API.userBase + "/savefiletodb", filetype: filetype, token: App.userinfos.token);
  }

  // downloadFileFromdb 从数据库下载文件
  static Future<dynamic> downloadFileFromdb(int id, {String filename}) {
    return App.request.download(API.userBase + "/downloadfilefromdb?id=$id", filename: filename);
  }

  // 查询上传文件
  static Future<dynamic> delUploadfileById(int id) {
    // print("findUploadfiles,查询文件");
    return App.request.post(
        API.userBase + "/getData",
        jsonEncode({
          "body": {
            "method": "exec/uploadfile/delbyid",
            "params": {"id": id}
          }
        }));
  }
}

// 包含用户所有信息
class Userinfos {
  String token;
  User user;
  List<Label> labels;
  Userinfos();
  Userinfos.fromTongji(Tongji tj) {
    token = tj.header.token;
    user = User.fromJson(tj.body.data[0]);
    labels = Label.fromList(tj.body.data[1]);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map();
    data["token"] = token;
    if (user != null) data["user"] = user.toJson();
    if (labels != null) {
      List<Map<String, dynamic>> ls = List();
      labels.forEach((l) => ls.add(l.toJson()));
      data["labels"] = ls;
    }
    return data;
  }
}

class User {
  int id;
  // 对应微信ID
  String userid;
  String name;
  String departmentname;
  String mobile;
  String email;
  String avatar;
  String position;
  User();
  User.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    id = json["id"];
    userid = json["userid"];
    departmentname = json["departmentname"];
    mobile = json["mobile"];
    email = json["email"];
    avatar = json["avatar"];
    position = json["position"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = Map();
    json["name"] = name;
    json["id"] = id;
    json["userid"] = userid;
    json["departmentname"] = departmentname;
    json["mobile"] = mobile;
    json["email"] = email;
    json["avatar"] = avatar;
    json["position"] = position;
    return json;
  }

  static List<User> fromList(List<dynamic> list) {
    List<User> users = List();
    list.forEach((json) {
      users.add(User.fromJson(json));
    });
    return users;
  }
}

// 用户标签,即用户角色
class Label {
  int labelid;
  int uId;
  String labelname;
  String describe;
  Label(this.labelid, this.labelname, this.describe);
  Label.fromJson(Map<String, dynamic> json) {
    if (json["id"] == null) {
      labelid = json["tagId"];
    } else {
      labelid = json["id"];
    }
    uId = json["uId"];
    labelname = json["tagName"];
    describe = json["describe"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = Map();
    json["id"] = labelid;
    json["tagName"] = labelname;
    json["describe"] = describe;
    return json;
  }

  static List<Label> fromList(List<dynamic> list) {
    List<Label> labels = List();
    list.forEach((json) {
      labels.add(Label.fromJson(json));
    });
    return labels;
  }
}

// 部门
class Department {
  int id;
  String name;
  int parentid;
  bool check = false;
  String leader;
  int role;
  // 表示部门类型，1-经营采编类，2-行政后勤类
  int attribute;
  String avatar;
  List<Department> children;
  Department();
  Department.fromBean(Department bean) {
    id = bean.id;
    name = bean.name;
    parentid = bean.parentid;
    leader = bean.leader;
    avatar = bean.avatar;
    attribute = bean.attribute;
  }
  static List<Department> fromList(List<dynamic> list) {
    List<Department> dep = List();
    if (list != null)
      list.forEach((json) {
        dep.add(Department.fromJson(json));
      });
    return dep;
  }

  Department.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    parentid = json["parentid"];
    leader = json["leader"];
    role = json["role"];
    avatar = json["avatar"];
    attribute = json["attribute"];
    children = fromList(json["children"]);
  }
  Map toJson() {
    Map json = new Map();
    json["id"] = id;
    json["name"] = name;
    json["parentid"] = parentid;
    json["leader"] = leader;
    json["role"] = role;
    json["avatar"] = avatar;
    json["attribute"] = attribute;
    json["children"] = children;
    return json;
  }
}

// 分管部门
class Leadership {
  int id;
  int userid;
  int departmentid;
  String departmentname;
  Leadership.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userid = json["user_id"];
    departmentid = json["department_id"];
    departmentname = json["department_name"];
  }
  static List<Leadership> fromList(List<dynamic> list) {
    List<Leadership> re = List();
    if (list != null) {
      list.forEach((l) => re.add(Leadership.fromJson(l)));
    }
    return re;
  }
}
