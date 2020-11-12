import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/http/user_api.dart';
import 'package:fznews/tongji/model/tongji_model.dart';
import 'package:fznews/user/user_autocomplete.dart';

class UpdateDepartmentLeaderWidget extends StatefulWidget {
  final Department bean;
  UpdateDepartmentLeaderWidget({Key key, this.bean}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _UpdateDepartmentLeaderWidgetState();
  }
}

class _UpdateDepartmentLeaderWidgetState extends State<UpdateDepartmentLeaderWidget> {
  Department _bean;
  List<Department> leaders;
  List<Widget> items;
  @override
  void initState() {
    super.initState();
    _bean = widget.bean;
    items = List();
    if (leaders == null) leaders = List();
    this.getLeaders();
  }

  void updateAttribue() {
    int attribute = 1;
    if (_bean.attribute == 1) {
      attribute = 2;
    }
    UserAPI.updateDepartment(_bean.id, attribute: attribute).then((data) {
      if (data["status"] != 200) {
        App.showAlertError(context, data["message"]);
        return;
      }
      _bean.attribute = attribute;
      App.showAlertInfo(context, "修改成功");
      setState(() {});
    });
  }

  void insert(var user, int role) {
    if (user == null) return;
    UserAPI.addLeadership([_bean], user.id, role: role).then((data) {
      if (data["status"] != 200) {
        App.showAlertError(context, data["message"]);
        return;
      }
      App.showAlertInfo(context, "成功");
      this.getLeaders();
    });
  }

  void setItems() {
    items = List();
    items.add(ListTile(
      leading: Icon(Icons.home),
      title: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text("${_bean.name}:"),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              "${_bean.attribute == 1 ? "采编经营类" : "行政后勤类"}",
              style: TextStyle(fontSize: 10, color: Colors.green),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              updateAttribue();
            },
          )
        ],
      ),
    ));
    items.add(ListTile(
        leading: FlatButton.icon(
      icon: Icon(Icons.add_circle),
      label: Text("分管领导"),
      onPressed: () {
        App.showAlertDialog(context, Text("添加分管领导"), UserAutocompleteWidget(
          callback: (user) {
            // print("id:${user.id},name:${user.name}");
            insert(user, 6);
          },
        ));
      },
    )));
    items.add(ListTile(
        leading: FlatButton.icon(
      icon: Icon(Icons.add_circle),
      label: Text("部门领导"),
      onPressed: () {
        App.showAlertDialog(context, Text("添加部门领导"), UserAutocompleteWidget(
          callback: (user) {
            // print("id:${user.id},name:${user.name}");
            insert(user, 5);
          },
        ));
      },
    )));
    items.addAll(leaders
        .map((l) => ListTile(
              leading: CircleAvatar(
                child: Image.network(l.avatar),
              ),
              title: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text("" + l.leader),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      "" + _rolename(l.role),
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_forever),
                    onPressed: () {
                      delLeader(l.id);
                    },
                  )
                ],
              ),
            ))
        .toList());
  }

  // 5-部门领导,6-分管领导，7-常务副总编，8-总编，9-社长
  String _rolename(int id) {
    String rolename;
    switch (id) {
      case 5:
        rolename = "部门主任";
        break;
      case 6:
        rolename = "分管领导";
        break;
      case 7:
        rolename = "常务副总编";
        break;
      case 8:
        rolename = "总编";
        break;
      case 9:
        rolename = "社长";
        break;
      default:
        rolename = "未知";
    }
    return rolename;
  }

  void delLeader(int id) {
    UserAPI.delLeadership([id]).then((data) {
      if (data["status"] != 200) {
        App.showAlertError(context, data["message"]);
        return;
      }
      leaders.removeWhere((l) => l.id == id);
      setItems();
      setState(() {});
    });
  }

  void getLeaders() {
    if (_bean == null) return;
    UserAPI.getLeadership(departmentid: _bean.id).then((data) {
      if (data["status"] != 200) {
        App.showAlertError(context, data["message"]);
        return;
      }
      var result = Tongji.fromJson(data["message"]);
      leaders = Department.fromList(result.body.data[0]);
      setItems();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // 分行显示分管领导
    return Container(
        width: 400,
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            children: items,
          ),
        ));
  }
}
