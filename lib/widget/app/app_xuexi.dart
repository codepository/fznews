import 'package:flutter/material.dart';
import 'package:fznews/home_page.dart';
import 'package:fznews/routes.dart';
import 'package:fznews/widget/appbar/app_bar_xuexi.dart';

class XueXiApp extends StatefulWidget{
  final Widget title;
  final List<RouteHandler> tabs;
  final params;
  final leading;
  final callback;
  XueXiApp({Key key,this.title,this.tabs,this.params,this.leading,this.callback}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _XueXiAppState();
  }

}
class _XueXiAppState extends State<XueXiApp>{
  Color _backgroundColor;
  @override
  void initState(){
    super.initState();
    _backgroundColor=Colors.red;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

        body: NestedScrollView(
          body: HomePage(),
          headerSliverBuilder: (BuildContext context,bool innerBoxIsScrolled){
            return <Widget>[
              XueXiAppBar(
                title: widget.title,
                tabs: widget.tabs,
                backgroundColor: _backgroundColor,
                leading: widget.leading,
                flexibleSpaceBarHeight: 100,
                callback: widget.callback,
              )
            ];
          },
        ),
      ),
    );
  }
  
}