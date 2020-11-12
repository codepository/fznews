import 'package:flutter/material.dart';
import 'package:fznews/http/tongji_api.dart';
import 'package:fznews/routes.dart';
import 'package:fznews/tongji/model/tongji_model.dart';
import 'package:fznews/widget/editor_flow_card.dart';
class EditorRankFlow extends StatefulWidget  {
   final List<dynamic> data;
   EditorRankFlow({Key key,this.data}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _EditorRankFlowState();
  }
}

class _EditorRankFlowState extends State<EditorRankFlow> with AutomaticKeepAliveClientMixin{
  Tongji monthParams;
  List<dynamic> _data;
  void initParam(){
    monthParams=Tongji();
    monthParams.body.method = "visit/editor/flowWithAvators";
    monthParams.body.startDate = '${DateTime.now().subtract(Duration(days:29))}'.substring(0,10);
    monthParams.body.endDate = '${DateTime.now()}'.substring(0,10);
    monthParams.body.maxResults = 3;
    monthParams.body.startIndex = 0;
  }
  Future<dynamic> getDatas() async{
    var data1 = await TongjiAPI.getData(monthParams.toJson());
    var result1 = Tongji.fromJson(data1["message"]);
     if (data1["status"]!=200) {
        return;
      }
    return result1.body.data[0];
  }
  bool get wantKeepAlive => true;
  @override
  void initState(){
    super.initState();
    print('init editor flow rank2');
    initParam();
    _data=widget.data;
    if(_data==null){
      TongjiAPI.getData(monthParams.toJson()).then((data1){
        if (data1["status"]!=200) {
          return;
        }
        var result1 = Tongji.fromJson(data1["message"]);
        if (result1.body.data!=null){
          _data = result1.body.data[0];
           setState(() {
          });
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _data==null?Container():Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Text('编辑月度流量排行',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context,index){
              return EditorFlowCard(route: '${Routes.Editor_Detail}?username=${_data[index]["username"]}',
                        avatar: _data[index]["avatar"],title: '${_data[index]["realname"]}/ ${_data[index]["username"]}',
                        subtitle: "流量: ${_data[index]["pv_count"]} /访客数${_data[index]["visitor_count"]}/贡献下游浏览量${_data[index]["outward_count"]}",
                        star: _data[index]["star"],);
            },
            itemCount: _data.length,
          ),
        ],
      ),
    );
  }
  
}