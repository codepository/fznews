import 'package:flutter/material.dart';
import 'package:fznews/tongji/editor_flow_rank2.dart';

class HomePage extends StatelessWidget{
  final params;
  HomePage({Key key,this.params});
  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 600,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1/0.8
      ),
      children: <Widget>[
        EditorRankFlow(),
      ],
    );
  }
  
}