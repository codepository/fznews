import 'package:flutter/material.dart';
import 'package:fznews/routes.dart';
import 'package:fznews/widget/service/service_item.dart';
//  app搜索功能页面
class SearchRoutePage extends StatelessWidget {
  final List<dynamic> history;
  final List<dynamic> hot;
  SearchRoutePage({Key key,this.history,this.hot}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('搜索'),
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 80,
        padding: EdgeInsets.symmetric(vertical: 0),
        children: Routes.getSearchRegistry().map((item)=>ServiceItem(data:item)).toList(),
        // children: Routes.routerMap.map((k,v)=> MapEntry(k,ServiceItem(data: v,))).values.toList(),
      ),
    );
  }
  
}
