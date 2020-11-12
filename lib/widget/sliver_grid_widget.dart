import 'package:flutter/material.dart';

class SliverGridWidget extends StatelessWidget{
  final List<Widget> items;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final double maxCrossAxisExtent;
  final double gridHeight;
  SliverGridWidget({Key key,this.items,this.crossAxisSpacing,this.childAspectRatio,this.maxCrossAxisExtent,this.gridHeight}):assert(items!=null),super(key:key);
  double getMaxCrossAxisExtent(){
    return maxCrossAxisExtent!=null?maxCrossAxisExtent:600;
  }
  double getChildAspectRatio(){
    if (this.gridHeight!=null) {
      return maxCrossAxisExtent/gridHeight;
    }
    return childAspectRatio==null?1:childAspectRatio;
  }
  @override
  Widget build(BuildContext context) {
    // print("build sliver grid:${items.length}");
    if (items.length==0){
      return SliverToBoxAdapter(
      );
    }
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context,int index){
          return items[index];
        },
        childCount: items.length
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: getMaxCrossAxisExtent(),
        // crossAxisSpacing: crossAxisSpacing!=null?crossAxisSpacing:10.0,
        childAspectRatio: getChildAspectRatio(),
      ),
    );
  }
  
}