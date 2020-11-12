import 'package:flutter/material.dart';
import 'package:fznews/http/user_api.dart';
import 'package:fznews/tongji/model/tongji_model.dart';
import 'package:fznews/widget/tree_item_widget.dart';

import '../app.dart';
import 'UpdateDepartmentLeaderWidget.dart';
// DepartmentWidget 显示部门列表
class DepartmentWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DepartmentWidgetState();
  }
  
}
class _DepartmentWidgetState extends State<DepartmentWidget> {
  List<dynamic> _data;
  @override void initState(){
    super.initState();
    _data=List();
    this.getDatas(false);
  }
  void getDatas(bool refresh){
    UserAPI.getAllDepartments(refresh: refresh).then((data){
      if (data["status"]!=200){
        App.showAlertError(context,data["message"]);
        return;
      }
      var result=Tongji.fromJson(data["message"]);
      _data=Department.fromList(result.body.data[0]);
      setState(() {
        
      });
    });
  }
  @override
  Widget build(BuildContext context) {
      return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
        itemBuilder: (BuildContext context,int index)=>TreeItemWidget(bean:_data[index],showLeader: true,updateLeaderCallback: (val){
          // print(jsonEncode(val));
          App.showAlertDialog(context,Text('修改部门负责人'),UpdateDepartmentLeaderWidget(bean: val,));
        },),
        itemCount: _data.length,
      ),
      ),
    );
  }
  
}