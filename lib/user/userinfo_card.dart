import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/http/user_api.dart';
import 'package:fznews/tongji/model/tongji_model.dart';
import 'package:fznews/widget/chip/chipfilter_group.dart';
import 'package:fznews/widget/tree_widget.dart';

class UserinfoCard extends StatefulWidget {
  final String userid;
  // 微信用户id
  final String wxuserid;
  UserinfoCard({Key key, this.userid, this.wxuserid})
      : assert(wxuserid != null),
        super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _UserinfoCardState();
  }
}

class _UserinfoCardState extends State<UserinfoCard> {
  List<dynamic> _data;
  String _userid;
  String _wxuserid;
  Tongji params;
  Map<String, dynamic> user;
  String _userLevel;
  List<dynamic> labels;
  List<dynamic> allLabels;
  List<dynamic> labelsReadyToAdd;
  // 用户分管的部门
  List<Leadership> leaderships;
  List<Department> departments;
  List<dynamic> _departmentSelected;
  @override
  void initState() {
    super.initState();
    params = Tongji();
    _userid = widget.userid;
    _wxuserid = widget.wxuserid;
    this.getData();
    this.getLeadership(int.parse(_userid));
  }

  void addLeadership(List<dynamic> departments) {
    UserAPI.addLeadership(departments, _wxuserid).then((data) {
      if (data["status"] != 200) {
        App.showAlertError(context, data["message"]);
        return;
      }
      this.getLeadership(int.parse(_userid));
      setState(() {});
    });
  }

  void delLeadership(Leadership l) {
    UserAPI.delLeadership([l.id]).then((data) {
      if (data["status"] != 200) {
        App.showAlertError(context, data["message"]);
        return;
      }
      leaderships.removeWhere((item) => item.id == l.id);
      setState(() {});
    });
  }

  void getLeadership(int userid) {
    leaderships = List();
    UserAPI.getLeadership(userid: userid).then((data) {
      if (data["status"] != 200) {
        return;
      }
      var result = Tongji.fromJson(data["message"]);
      leaderships = Leadership.fromList(result.body.data[0]);
      setState(() {});
    });
  }

  void getDepartment() async {
    if (departments != null) {
      showDepartment();
      return;
    }
    UserAPI.getAllDepartments().then((data) {
      if (data["status"] == 200) {
        var result = Tongji.fromJson(data["message"]);
        departments = Department.fromList(result.body.data[0]);
        showDepartment();
      }
    });
  }

  void showDepartment() {
    App.showAlertDialog(
        context,
        Text('添加分管部门'),
        TreeWidget(
          data: departments,
          multiple: true,
          callback: (val) {
            _departmentSelected = val;
          },
        ), callback: () {
      this.addLeadership(_departmentSelected);
    });
  }

  void setParams() {
    params.body.method = "visit/user/getUserByID";
    params.body.metrics = _userid;
  }

  void getData() async {
    setParams();
    UserAPI.getData(params.toJson()).then((data) {
      if (data["status"] != 200) {
        return;
      }
      var result = Tongji.fromJson(data["message"]);
      _data = result.body.data;
      user = _data[0];
      switch (user["level"]) {
        case 0:
          _userLevel = "一般员工";
          break;
        case 1:
          _userLevel = "中层正职（含主持工作的副职）";
          break;
        case 2:
          _userLevel = "中层副职";
          break;
        case 3:
          _userLevel = "社领导";
          break;
        default:
      }
      labels = _data[1];
      setState(() {});
    });
  }

  void alertAddLable() {
    App.showAlertDialog(
        context,
        Text("添加角色"),
        FilterChipGroup(
            labels: allLabels,
            callback: (val) {
              if (val == null) return;
              var l = val.map((label) {
                var x = Label.fromJson(label);
                return {"tagId": x.labelid, "tagName": x.labelname, "uId": int.parse(_userid)};
              }).toList();
              labelsReadyToAdd = l;
            }), callback: () {
      addLabel(labelsReadyToAdd);
    });
  }

  void getAllLabel() async {
    if (allLabels != null) {
      alertAddLable();
      return;
    }
    UserAPI.getAllLabels().then((data) {
      if (data["status"] == 200) {
        var result = Tongji.fromJson(data["message"]);
        allLabels = result.body.data[0];
        alertAddLable();
      } else {
        App.showAlertDialog(context, Text("错误"), Text(data["message"]));
      }
    });
  }

  void addLabel(var _labels) {
    params.body.method = "exec/user/addlabel";
    params.body.data = _labels;
    params.header.token = App.getToken();
    UserAPI.getData(params.toJson()).then((data) {
      if (data["status"] == 200) {
        setState(() {
          labels.addAll(_labels);
        });
      } else {
        App.showAlertDialog(context, Text("错误"), Text(data["message"]));
      }
    });
  }

  void deleteLabel(Label label) {
    params.body.method = "exec/user/dellabel";
    params.body.data = List();
    params.body.data.add({"uId": label.uId, "tagId": label.labelid});
    params.header.token = App.getToken();
    UserAPI.getData(params.toJson()).then((data) {
      if (data["status"] == 200) {
        // labels.removeAt(index);
        // print("$labels");
        labels.removeWhere((item) => item["tagId"] == label.labelid);
        setState(() {});
      } else {
        App.showAlertDialog(context, Text("错误"), Text(data["message"]));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_data == null || _data.length == 0)
      return Center(
        child: Text('用户信息为空'),
      );
    TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold);
    return Center(
      child: CustomScrollView(
        controller: ScrollController(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Text(
                    '用户信息',
                    style: textStyle,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  user["is_leader"] == 1
                      ? Text(
                          "部门领导",
                          style: TextStyle(color: Colors.blue),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: user["avatar"] == null
                    ? Text(user["name"])
                    : Image.network(
                        user["avatar"],
                      ),
              ),
              title: Text("${user["name"]}/$_userLevel"),
              subtitle: Text('${user["departmentname"]}/${user["position"]}'),
            ),
          ),
          // 用户标签
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Text(
                    '用户角色',
                    style: textStyle,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: RawChip(
                      label: Text('添加'),
                      backgroundColor: Colors.lightBlue,
                      elevation: 1,
                      onPressed: () {
                        getAllLabel();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Wrap(
              children: labels.map((l) {
                var x = Label.fromJson(l);
                print(x.labelid);
                return RawChip(
                  label: Text(x.labelname),
                  tooltip: x.describe,
                  onDeleted: () {
                    App.showAlertDialog(context, Text('提示'), Text('确定要删除吗？'), callback: () {
                      deleteLabel(x);
                    });
                  },
                  deleteIcon: Icon(Icons.delete),
                  deleteIconColor: Colors.red,
                  deleteButtonTooltipMessage: '删除',
                );
              }).toList(),
            ),
          ),
          // 分管部门
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Text(
                    '分管部门',
                    style: textStyle,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: RawChip(
                      label: Text('添加'),
                      backgroundColor: Colors.lightBlue,
                      elevation: 1,
                      onPressed: () {
                        this.getDepartment();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Wrap(
              children: leaderships.map((l) {
                return RawChip(
                  label: Text(l.departmentname),
                  onDeleted: () {
                    App.showAlertDialog(context, Text('提示'), Text('确定要删除吗？'), callback: () {
                      delLeadership(l);
                    });
                  },
                  deleteIcon: Icon(Icons.delete),
                  deleteIconColor: Colors.red,
                  deleteButtonTooltipMessage: '删除',
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
