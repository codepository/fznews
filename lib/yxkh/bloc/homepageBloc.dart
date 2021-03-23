import 'dart:convert';

import 'package:fznews/app.dart';
import 'package:fznews/http/response_data.dart';
import 'package:fznews/http/user_api.dart';
import 'package:fznews/http/yxkh_api.dart';
import 'package:rxdart/rxdart.dart';

// 一线考核首页数据管理模块
abstract class HomePageBloc {
  void dispose();
  // remarksFileStream 获取嘉奖文件数据流
  Stream<List<dynamic>> get remarksFileStream;
  Stream<List<dynamic>> get publicFileStream;
  Stream<List<dynamic>> get taskRankStream;
  Stream<List<dynamic>> get marksRankStream;
  Stream<List<dynamic>> get fullyearRankStream;
  Stream<List<dynamic>> get halfyearRankStream;
  Stream<List<dynamic>> get groupsStream;
  // 上月一线考核提交和审批情况
  Stream<List<dynamic>> get completeDescribeStream;
  // 上月月度考核未交清单
  Stream<List<dynamic>> get personUnApplyStream;
  List<dynamic> get groups;
  setRemarksFile(List<dynamic> items);
  setPublicFile(List<dynamic> items);
  setTaskRank(List<dynamic> items);
  setMarksRank(List<dynamic> items);
  setFullyearRank(List<dynamic> items);
  setHalfyearRank(List<dynamic> items);
  setGroups(List<dynamic> items);
  setCompleteDescribe(List<dynamic> items);
  setPersonUnApply(List<dynamic> items);
  void onAddRemarksFile();
  void onAddPublicFile();
  void onDelRemarksFile(dynamic item);
  void onDelPublicFile(dynamic item);
  void onSearchRemarksFile({String filename});
  void onSearchPublicFile({String filename});
  void onSearchFullyearRank();
  void onSearchHalfyearRank();
  void nextPageRemarksFile();
  void nextPagePublicFile();
  void prePageRemarksFile();
  void prePagePublicFile();
}

class HomePageBlocImpl implements HomePageBloc {
  // 一线考核首页数据
  List<dynamic> homedata;
  BehaviorSubject<List<dynamic>> _remarksFile = BehaviorSubject.seeded(List());
  BehaviorSubject<List<dynamic>> _publicFile = BehaviorSubject.seeded(List());
  BehaviorSubject<List<dynamic>> _taskRank = BehaviorSubject.seeded(List());
  BehaviorSubject<List<dynamic>> _marksRank = BehaviorSubject.seeded(List());
  BehaviorSubject<List<dynamic>> _fullyearRank = BehaviorSubject.seeded(List());
  BehaviorSubject<List<dynamic>> _halfyearRank = BehaviorSubject.seeded(List());
  // 考核组
  BehaviorSubject<List<dynamic>> _groups = BehaviorSubject.seeded(List<dynamic>());
  // 上月一线考核提交和审批情况
  BehaviorSubject<List<dynamic>> _completeDescribe = BehaviorSubject.seeded(List());
  // 上月月度考核未提交情况
  BehaviorSubject<List<dynamic>> _personUnApply = BehaviorSubject.seeded(List());
  // 当前的嘉奖文件
  List<dynamic> _curRemarksFile = List();
  List<dynamic> _curPublicFile = List();
  // 当前嘉奖文件所在页数
  int remarksFilePageIndex = 0;
  int publicFilePageIndex = 0;
  String remarksFilename;
  String publicFilename;
  dynamic fullyearRankParams;
  dynamic halfyearRankParams = Map();
  bool hasData = false;
  HomePageBlocImpl() {
    fullyearRankParams = {"limit": 20, "offset": 0, "sparation": YXKHAPI.getYearAssessType()};
    // this.findHomeData();
    halfyearRankParams = {"limit": 20, "offset": 0};
  }
  @override
  void dispose() {
    _remarksFile.close();
    _publicFile.close();
    _taskRank.close();
    _marksRank.close();
    _fullyearRank.close();
    _halfyearRank.close();
    _completeDescribe.close();
    _personUnApply.close();
  }

// getDatas 获取远程首页数据
  Future<dynamic> getDatas({bool refresh = false}) async {
    return YXKHAPI.findYXKHHomedata(refresh: refresh);
  }

  void setHomeData(dynamic data) {
    hasData = true;
    var datas = ResponseData.fromResponse(data);
    homedata = datas;
    List<dynamic> groups = List();
    homedata[9].forEach((item) {
      groups.add({"key": item, "value": item});
    });
    App.sharedPreferences.setString("groups", jsonEncode(groups));
    this.setGroups(groups);
    this.setCompleteDescribe(homedata[1]);
    this.setRemarksFile(homedata[7][0]);
    this.setPublicFile(homedata[8][0]);
    this.setTaskRank(homedata[2]);
    this.setPersonUnApply(homedata[3]);
    this.setMarksRank(homedata[4]);
    this.setFullyearRank(homedata[5]);
    this.setHalfyearRank(homedata[6]);
  }

  void findHomeData({bool refresh = false}) {
    YXKHAPI.findYXKHHomedata(refresh: refresh).then((data) {
      setHomeData(data);
    });
  }

  @override
  // 获取一线考核嘉奖通报文件数据
  Stream<List> get remarksFileStream => _remarksFile.stream;
  Stream<List> get publicFileStream => _publicFile.stream;

  @override
  setRemarksFile(List items) {
    _remarksFile.add(items);
    _curRemarksFile = items;
  }

  @override
  setPublicFile(List items) {
    _publicFile.add(items);
    _curPublicFile = items;
  }

  @override
  void onDelRemarksFile(item) {
    UserAPI.delUploadfileById(item["id"]).then((data) {
      if (data["status"] != 200) {
        print("删除上传文件:$data");
        return;
      }
      _curRemarksFile.removeWhere((d) => d["id"] == item["id"]);
      _remarksFile.add(_curRemarksFile);
    });
  }

  @override
  void onAddRemarksFile() {
    remarksFilePageIndex = 0;
    onSearchRemarksFile();
  }

  @override
  void onSearchRemarksFile({String filename}) {
    // print("onSearchRemarksFile,查询文件");
    if (filename != null) {
      remarksFilename = filename;
    }
    UserAPI.findUploadfiles(
            fields: "id,filename",
            filetype: "remarks",
            filename: remarksFilename,
            limit: 10,
            offset: (remarksFilePageIndex - 1) * 10)
        .then((data) {
      var datas = ResponseData.fromResponse(data);
      this.setRemarksFile(datas[0]);
    });
  }

  @override
  void nextPageRemarksFile() {
    this.remarksFilePageIndex++;
    this.onSearchRemarksFile();
  }

  @override
  void prePageRemarksFile() {
    if (remarksFilePageIndex <= 1) {
      return;
    }
    remarksFilePageIndex--;
    this.onSearchRemarksFile();
  }

  @override
  Stream<List> get marksRankStream => _marksRank.stream;

  @override
  setMarksRank(List items) {
    _marksRank.add(items);
  }

  @override
  setTaskRank(List items) {
    _taskRank.add(items);
  }

  @override
  Stream<List> get taskRankStream => _taskRank.stream;

  @override
  void nextPagePublicFile() {
    this.publicFilePageIndex++;
    this.onSearchPublicFile();
  }

  @override
  void onAddPublicFile() {
    publicFilePageIndex = 0;
    onSearchPublicFile();
  }

  @override
  void onDelPublicFile(item) {
    UserAPI.delUploadfileById(item["id"]).then((data) {
      if (data["status"] != 200) {
        print("删除上传文件:$data");
        return;
      }
      _curPublicFile.removeWhere((d) => d["id"] == item["id"]);
      _publicFile.add(_curPublicFile);
    });
  }

  @override
  void onSearchPublicFile({String filename}) {
    if (filename != null) {
      publicFilename = filename;
    }
    UserAPI.findUploadfiles(
            fields: "id,filename",
            filetype: "public",
            filename: publicFilename,
            limit: 10,
            offset: (publicFilePageIndex - 1) * 10)
        .then((data) {
      var datas = ResponseData.fromResponse(data);
      this.setPublicFile(datas[0]);
    });
  }

  @override
  void prePagePublicFile() {
    if (publicFilePageIndex <= 1) {
      return;
    }
    publicFilePageIndex--;
    this.onSearchPublicFile();
  }

  @override
  Stream<List> get fullyearRankStream => _fullyearRank.stream;

  @override
  Stream<List> get halfyearRankStream => _halfyearRank.stream;

  @override
  void onSearchFullyearRank() {
    YXKHAPI.findAllEvalutionRank(this.fullyearRankParams).then((data) {
      if (data["status"] != 200) {
        print("查询年度考核:${data["message"]}");
        return;
      }
      var datas = ResponseData.fromResponse(data);
      this.setFullyearRank(datas[0]);
    });
  }

  @override
  void onSearchHalfyearRank() {
    YXKHAPI.findAllEvalutionRank(this.halfyearRankParams).then((data) {
      if (data["status"] != 200) {
        print("查询年度考核:${data["message"]}");
        return;
      }
      var datas = ResponseData.fromResponse(data);
      this.setHalfyearRank(datas[0]);
    });
  }

  @override
  setFullyearRank(List items) {
    _fullyearRank.add(items);
  }

  @override
  setHalfyearRank(List items) {
    _halfyearRank.add(items);
  }

  @override
  Stream<List<dynamic>> get groupsStream => _groups.stream;

  @override
  setGroups(List items) {
    this._groups.add(items);
  }

  @override
  List<dynamic> get groups => jsonDecode(App.sharedPreferences.get("groups"));

  @override
  Stream<List> get completeDescribeStream => _completeDescribe.stream;

  @override
  setCompleteDescribe(List datas) {
    Map<String, int> map = {"一": 0, "二": 1, "三": 2, "四": 3, "五": 4, "六": 5, "七": 6, "八": 7, "九": 8, "十": 9};
    int size = datas[3].length;
    List<dynamic> result = List(3);
    List<int> apply = List(size);
    List<int> complete = List(size);
    List<String> groups = List(size);
    for (int i = 0; i < size; i++) {
      int index = map[datas[3][i].substring(1, 2)];
      // print("INDEX:$index");
      apply[index] = ((datas[1][i] * 100 / datas[0][i]).round());
      complete[index] = ((datas[2][i] * 100 / datas[0][i]).round());
      groups[index] = datas[3][i];
    }
    result[0] = apply;
    result[1] = complete;
    result[2] = groups;
    this._completeDescribe.add(result);
  }

  @override
  Stream<List> get personUnApplyStream => _personUnApply.stream;

  @override
  setPersonUnApply(List items) {
    _personUnApply.add(items);
  }
}
