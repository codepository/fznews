import 'dart:convert';

import 'package:fznews/http/response_data.dart';
import 'package:fznews/http/yxkh_api.dart';
import 'package:rxdart/rxdart.dart';

abstract class YxkhMarksPrincipleBloc {
  void dispose();
  Stream<List<dynamic>> get stream;
  Future<dynamic> onAdd(item);
  Future<dynamic> onDel(dynamic item);
  void onSearch({String valueLike});
  Future<dynamic> exportMarksPriciple();
  Future<dynamic> importMarksPriciple();
}

class YxkhMarksPrincipleBlocImpl implements YxkhMarksPrincipleBloc {
  List<dynamic> datas;
  BehaviorSubject<List<dynamic>> _datasStream = BehaviorSubject.seeded(List());
  Map<String, dynamic> params;
  YxkhMarksPrincipleBlocImpl() {
    params = {"limit": 20, "offset": 0, "name": "评分依据"};
    this.onSearch();
  }

  @override
  void dispose() {
    _datasStream.close();
  }

  @override
  Future<dynamic> onDel(id) async {
    var data = await YXKHAPI.delDict(id);
    if (data["status"] == 200) {
      this.datas.removeWhere((item) => item["ID"] == id);
      _datasStream.add(this.datas);
      return "成功";
    }
    return data["message"];
  }

  @override
  void onSearch({String valueLike = ""}) {
    if (valueLike.length > 0) {
      this.params["value"] = valueLike;
    }
    YXKHAPI.findAllDict(this.params).then((data) {
      var datas = ResponseData.fromResponse(data);
      _datasStream.add(datas[0]);
      this.datas = datas[0];
    });
  }

  @override
  Stream<List> get stream => _datasStream.stream;

  @override
  Future onAdd(item) async {
    throw UnimplementedError();
  }

  @override
  Future exportMarksPriciple() async {
    YXKHAPI.exportMarksPriciple();
  }

  @override
  Future importMarksPriciple() async {
    var datas = await YXKHAPI.importMarksPriciple();
    return datas;
  }
}
