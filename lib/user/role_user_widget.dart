import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/http/user_api.dart';
import 'package:fznews/tongji/model/tongji_model.dart';
import 'package:fznews/widget/tree_widget.dart';
class LabelWithUserWidget extends StatefulWidget{
  final params;
  LabelWithUserWidget({Key key,this.params}):assert(params!=null),super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _LabelWithUserWidgetState();
  }

}
class _LabelWithUserWidgetState extends State<LabelWithUserWidget>{
  var _label;
  Tongji params=Tongji();
  List<User> users;
  List<Department> departments;
  List<dynamic> _departmentSelected;
  Label label;
  @override void initState(){
    super.initState();
     
    _label=jsonDecode(widget.params["label"]?.first);
    label = Label.fromJson(_label);
    params.body.method="visit/user/findbylabelids";
    params.body.maxResults=20;
    users=List();
    this.getUsers();
    this.getDepartment();
  
  }
  void getDepartment() async{
    if (departments!=null) return; 
    UserAPI.getAllDepartments().then((data){
      if (data["status"]==200){
        var result= Tongji.fromJson(data["message"]);
        departments=Department.fromList(result.body.data[0]);
      }
    });
  }
  // 根据部门给用户贴标签
  void addLabelByDepartment(var deparments) async{
    UserAPI.addLabelByDepartments(label.labelid,deparments).then((data){
      if (data["status"]==200){
        this.getUsers();
      }else{
        App.showAlertDialog(context,Text("错误"),Text(data["message"]));
      }
    });
    
  }
  void getUsers() async{
    params.body.data=[label.labelid];
    UserAPI.getData(params.toJson()).then((data){
      if (data["status"]==200){
        var result= Tongji.fromJson(data["message"]);
        users=User.fromList(result.body.data[0]);
        setState(() {
          
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加用户'),
        leading: IconButton(
        onPressed: ()=>Navigator.pop(context),
        icon: Icon(Icons.arrow_back),
      ),
     ),
     body: CustomScrollView(
       slivers: <Widget>[
         SliverToBoxAdapter(
           child: Row(
             children: <Widget>[
               Text(label.labelname,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
               Padding(
                 padding: EdgeInsets.only(left: 10),
                 child: RawChip(
                 label: Text('添加用户'),
                 onPressed: (){
                   App.showAlertDialog(context,Text('添加用户'),TreeWidget(data: departments,multiple: true,callback: (val){
                     _departmentSelected=val;
                   },),callback: (){
                     this.addLabelByDepartment(_departmentSelected.map((d)=>d["id"]).toList());
                   });
                 },
               ),
               )
             ],
           ),
         ),
         SliverToBoxAdapter(
           child: Wrap(
             children: users.map((user){
               return CircleAvatar(
                 radius: 30,
                 child: Text(user.name),

               );
             }).toList(),
           ),
         )
       ],
     ),
    );
  }
  
}