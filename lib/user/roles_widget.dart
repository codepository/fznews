import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/http/user_api.dart';
import 'package:fznews/routes.dart';
import 'package:fznews/tongji/model/tongji_model.dart';

class RolesWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _RolesWidgetState();
  }

}
class _RolesWidgetState extends State<RolesWidget>{
  ScrollController _scrollController;
  Map<String,List<dynamic>> labelsGroup;
  List<ExpansionPanel> rolesExpansionList;
  int currentExpended;
  List<Widget> headers;
  @override void initState(){
    super.initState();
    _scrollController=ScrollController();
    this.getRoles();
    headers=List();
    headers.add(
      RawChip(
        label: Text('添加新标签'),
        onPressed: (){
          App.router.navigateTo(context,Routes.AddLabels);
        },
      )
    );
  }
  @override void dispose(){
    super.dispose();
    _scrollController.dispose();
  }
  void getRolesExpansionPanelList(){
    if (labelsGroup==null) return;
    rolesExpansionList=List();
    currentExpended=0;
    var i=0;
    labelsGroup.forEach((key,list){
      rolesExpansionList.add(
        ExpansionPanel(
              headerBuilder: (context,isExpanded){
                return Text(key);
              },
              body: ListBody(
                children: <Widget>[
                  Text(key)
                ],
              ),
              canTapOnHeader: true,
              isExpanded: i==currentExpended
            )
        );
        i++;
      }
    );
  }
  void getRoles({bool refresh}) async{
    if (labelsGroup!=null && !refresh) return;
    UserAPI.getAllLabels().then((data){
      if (data["status"]==200){
        var result=Tongji.fromJson(data["message"]);
        if (result.body.data.length==0) return;
        labelsGroup=Map();
        result.body.data[0].forEach((item){
          if (labelsGroup[item["type"]]==null ) labelsGroup[item["type"]]=[];
          labelsGroup[item["type"]].add(item);
        });
        getRolesExpansionPanelList();
        setState(() {
          
        });
      } else {
        App.showAlertDialog(context,Text("报错"),Text(jsonEncode(data["message"])));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
       var i=-1;
       return rolesExpansionList==null?Container():CustomScrollView(
         slivers: <Widget>[
           SliverToBoxAdapter(
             child: Wrap(
               children: headers
             ),
           ),
           SliverToBoxAdapter(
             child: ExpansionPanelList(
           children: labelsGroup.map((key,list){
             i++;
             return MapEntry(key,ExpansionPanel(
              headerBuilder: (context,isExpanded){
                return ListTile(
                  title: Text(key),
                );
              },
              body: Padding(
                padding: EdgeInsets.all(5),
                child: Wrap(
                  children: list.map((item){
                    return RawChip(
                      label: Text(item["tagName"]),
                      tooltip:item["describe"],
                      onPressed: (){
                        App.router.navigateTo(context,"${Routes.LabelWithUser}?label=${Uri.encodeComponent(jsonEncode(item))}");
                      },
                      onDeleted: (){
                         App.showAlertDialog(context,Text('删除'),Text('没有权限'));
                      },
                      deleteIcon: Icon(Icons.delete),
                      deleteIconColor: Colors.blue,
                      deleteButtonTooltipMessage: '删除标签',
                        );
                      }).toList(),
                )
              ),
              canTapOnHeader: true,
              isExpanded: i==currentExpended
            ));
           }).values.toList(),
           expansionCallback: (int index,bool isExpanded){
             setState(() {
               currentExpended=(currentExpended!=index?index:-1);
             });
           },
         ),
           )
         ],
       );
  }
  
}