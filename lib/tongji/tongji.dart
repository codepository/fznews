import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/routes.dart';
import 'package:fznews/tongji/article_rank.dart';
import 'package:fznews/tongji/editor_flow.dart';
import 'package:fznews/widget/app/app_basic.dart';

class TongjiWidget extends StatefulWidget {
  final params;
  TongjiWidget({Key key,this.params}):super(key:key);
  @override
  State<StatefulWidget> createState() {
   
    return _TongjiWidgetState();
  }
  
}
class  _TongjiWidgetState extends State<TongjiWidget> with TickerProviderStateMixin{
  List<RouteHandler> choices;
  List<RouteHandler> titleChoices;
  TabController tabController;
  Widget title;
  @override 
  void dispose(){
    super.dispose();
    tabController.dispose();
  }
  @override
  void initState(){
    super.initState();
    print('init TongjiWidget');
    choices =  <RouteHandler>[
        RouteHandler(title: '编辑', icon: Icons.people, handler:({Map<String,dynamic> params}){return EditorFlow();}),
        RouteHandler(title: '文章', icon: Icons.translate, handler:({Map<String,dynamic> params}){return ArticleRank();}),
    ];
    tabController=TabController(length: choices.length,vsync: this);

  }
  @override
  Widget build(BuildContext context) {
    return BasicApp(
      title: Text('流量统计'),
      actions: choices,
      tabs: choices,
      tabController: tabController,
      leading: IconButton(
        icon: Icon(Icons.home),
        onPressed: ()=>App.router.navigateTo(context,Routes.Dashboard),
      ),
    );
  }
}
