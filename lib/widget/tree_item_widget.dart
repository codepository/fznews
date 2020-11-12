import 'package:flutter/material.dart';
import 'package:fznews/http/user_api.dart';

class TreeItemWidget extends StatefulWidget{
  final bean;
  final bool multiple;
  final callback;
  final bool showLeader;
  final updateLeaderCallback;
  TreeItemWidget({Key key,this.bean,this.multiple=false,
  this.callback,this.showLeader=false,this.updateLeaderCallback
  }):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _TreeItemWidgetState();
  }
  
}
class _TreeItemWidgetState extends State<TreeItemWidget>{
  var _bean;
  bool _multiple;
  bool _showLeader;
  List<dynamic> _selected;
  var _callback;
  var _updateLeaderCallback;
  @override void initState(){
    super.initState();
    _bean=widget.bean;
    // if (_bean==null) _bean=List();
    _multiple=widget.multiple;
    _showLeader=widget.showLeader;
    _selected=List();
    _callback=widget.callback;
    _updateLeaderCallback=widget.updateLeaderCallback;
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildItem(_bean,0),
    );
  }
  void check(var bean){
    bool check=!bean.check;
    List<dynamic> temp=List();
    temp.add(bean);
    while(temp.length>0){
      var b=temp.removeLast();
      b.check=check;
      int index=_selected.indexWhere((item)=>item["id"]==b.id);
      if (!check&&index!=-1){
        _selected.removeAt(index);
      }else{
        // 点中、原先不存在，就添加
        if (check&&index==-1){
          var x=Map();
          x["name"]=b.name;
          x["id"]=b.id;
          _selected.add(x);
        }
      }
      if (b.children.length>0){
        temp.addAll(b.children);
      }
    }
    _callback(_selected);
  }
  Widget _buildItem(var bean,int level){
    Widget _leader=_showLeader?Row(children: <Widget>[
      bean.leader!=null?Padding(padding: EdgeInsets.only(left: 10),
        child: Text(""+bean.leader,style: TextStyle(
        color: Colors.grey,
        fontSize: 15,
      ),),
      ):Text(""),
      IconButton(
        icon: Icon(Icons.add_circle),
        iconSize: 15,
        onPressed: (){
          if(_updateLeaderCallback==null)return;
          Department d=Department.fromBean(bean);
          _updateLeaderCallback(d);
        },
      ),
    ],):Text("");
    if(bean.children.isEmpty){
      return ListTile(
        leading: CircleAvatar(
        radius: 13,
        child: Icon(Icons.home)
      ),
        title: !_multiple?Row(children: <Widget>[
          Text(bean.name),
          _leader
        ],):CheckboxListTile(
        title: Text(bean.name),
        value: bean.check,
        onChanged: (bool value){
          setState(() {
            check(bean);
          });
        },
      ),
      onTap: () {
        if(_callback==null)return;
        if (!_multiple){
          _selected.clear();
          _selected.add(bean);
          _callback(_selected);
        }
       },
      );
    }
    level++;
    return ExpansionTile(
        title: !_multiple?Row(children: <Widget>[
          Text(bean.name),
          _leader
        ],):CheckboxListTile(
        title: Text(bean.name),
        value: bean.check,
        onChanged: (bool value){
          setState(() {
            check(bean);
          });
        },
      ),
      children: bean.children.map<Widget>((b)=>_buildItem(b,level)).toList(),
      leading: CircleAvatar(
        radius: (5/level)*10,
        backgroundColor: Colors.green,
        child: Text(bean.name.substring(0,1),style: TextStyle(color: Colors.white),),
      ),
    );
  }
}