import 'package:flutter/material.dart';
import 'package:fznews/widget/tree_item_widget.dart';

class TreeWidget extends StatefulWidget{
  final data;
  final bool multiple;
  final callback;
  final width;
  final height;
  TreeWidget({Key key,this.data,this.multiple,this.callback,
    this.width,this.height
  }):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _TreeWidgetState();
  }

}
class _TreeWidgetState extends State<TreeWidget>{
  var _data;
  var _width;
  var _height;
  @override void initState(){
    super.initState();
    _data=widget.data;
    _width=widget.width;
    _height=widget.height;
    if (_data==null) _data=List();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: _width==null?400:_width,
        height: _height==null?500:_height,
        child: ListView.builder(
        itemBuilder: (BuildContext context,int index)=>TreeItemWidget(bean:_data[index],multiple:widget.multiple,callback: (val){
          widget.callback(val);
        },),
        itemCount: _data.length,
      ),
      ),
    );
  }
  
}