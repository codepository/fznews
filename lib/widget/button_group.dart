import 'package:flutter/material.dart';
// ButtonGroup 组合按键
// 效果：被点击变色，点击后返回被点击按键
class ButtonGroupWidget extends StatefulWidget{
  final List<ButtonData> datas;
  final EdgeInsets padding;
  // 最大宽度
  final double maxCrossAxisExtent;
  // 宽除以高
  final double childAspectRatio;
  // 回调函数,返回被激活的按键id
  // 每个组件最大高度
  final double maxHeight;
  // 每个按钮的宽度
  final double btnWidth;
  final double btnHeight;
  final ShapeBorder btnShape;
  final TextStyle btnTextStyle;
  final callback;
  ButtonGroupWidget({Key key,this.datas,
   this.padding,this.maxCrossAxisExtent,
   this.childAspectRatio,this.maxHeight,
   this.btnWidth,this.btnHeight,this.btnShape,this.btnTextStyle,
   this.callback}):super(key:key);

  @override
  State<StatefulWidget> createState() {

    return _ButtonGroupWidgetState();
  }

}
class _ButtonGroupWidgetState extends State<ButtonGroupWidget>{
  List<ButtonData> items;
  int activate;
  double maxWidth;
  double maxHeight;
  double groupwidth;
  double _btnHeight;
  double _btnWidth;

  @override
  void initState(){
    super.initState();
    _btnHeight = widget.btnHeight != null ? widget.btnHeight : 60;
    _btnWidth = widget.btnWidth !=null? widget.btnWidth:100;
    activate = 0;
    if (widget.datas==null) {
      items = List();
      for(var i=0;i<10;i++) {
        items.add(ButtonData(title:'button$i',normalcolor:Colors.white,activecolor:Colors.blue,id: i,height: _btnHeight,width: _btnWidth));
      }
    } else {
      items = widget.datas;
      for(var i=0;i<items.length;i++){
        items[i].id=i;
      }
    }
    groupwidth = _btnWidth * items.length;
    // setMaxWidthAndMaxHeight(context,widget.btnWidth * items.length,widget.btnHeight);

  }

  void setMaxWidthAndMaxHeight(BuildContext context,double groupwidth) {

    double mediaWidth = MediaQuery.of(context).size.width;
    // double groupwidth = widget.btnWidth * items.length;
    
    if (groupwidth <= mediaWidth) {
      // // print('media:$mediaWidth, group:$groupwidth, maxWidth:$maxWidth,maxHeight: $maxHeight,widget.btnWidth:${widget.btnWidth},widget.btnHeight:${widget.btnHeight}');
      maxWidth = groupwidth;
      maxHeight = _btnHeight;
      // // print('media:$mediaWidth, group:$groupwidth, maxWidth:$maxWidth,maxHeight: $maxHeight,widget.btnWidth:${widget.btnWidth},widget.btnHeight:${widget.btnHeight}');
    } else {
      maxWidth = mediaWidth;
      maxHeight = (groupwidth/mediaWidth).ceilToDouble() * (_btnHeight);
    }
    // // print('media:$mediaWidth, group:$groupwidth, maxWidth:$maxWidth,maxHeight: $maxHeight,widget.btnWidth:${widget.btnWidth},widget.btnHeight:${widget.btnHeight}');
    // // print('media:$mediaWidth, group:$groupwidth, maxWidth:$maxWidth,maxHeight: $maxHeight,widget.btnWidth:${widget.btnWidth},widget.btnHeight:${widget.btnHeight}');
  }
  @override
  Widget build(BuildContext context) {
    // print('button group');
    // // print('widget:${widget.btnWidth}');
    // // print('media:${MediaQuery.of(context).size.width},group:$groupwidth, maxWidth:$maxWidth,maxHeight: $maxHeight,widget.btnWidth:$_btnWidth,widget.btnHeight:$_btnHeight');
    setMaxWidthAndMaxHeight(context,this.groupwidth);
    // double groupwidth = widget.btnWidth * items.length;
    // // print('media:${MediaQuery.of(context).size.width},group:$groupwidth, maxWidth:$maxWidth,maxHeight: $maxHeight,widget.btnWidth:$_btnWidth,widget.btnHeight:$_btnHeight');
    return Container(
      constraints: BoxConstraints(
        // maxHeight: maxHeight,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        // maxWidth:600,
      ),
      child: Padding(
      padding: widget.padding!=null ? widget.padding:EdgeInsets.all(5.0),
      child: GridView.builder(
        // shrinkWrap: true,
        itemCount: items.length,
        // physics: NeverScrollableScrollPhysics(),
        // padding: widget.padding!=null ? widget.padding : EdgeInsets.symmetric(horizontal: 5),
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //   childAspectRatio: widget.childAspectRatio!=null?widget.childAspectRatio : 2,
        //   crossAxisCount: 10,
        // ),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: widget.childAspectRatio!=null?widget.childAspectRatio : 2,
          maxCrossAxisExtent: widget.maxCrossAxisExtent !=null ? widget.maxCrossAxisExtent : _btnWidth
        ),
        itemBuilder: (context, index){
          return Container(
            child: ButtonActiveWidget(btnTextStyle:widget.btnTextStyle,btnShape: widget.btnShape,data:items[index],callback: (index){
              setState(() {
                items[activate].active = 0;
                activate = index;
                items[activate].active = 1;
                widget.callback(activate);
              });
            },),
          );
        },
      ),
    ),
    );
  }
  
}

class ButtonActiveWidget extends StatefulWidget{
  final ButtonData data;
  final callback;
  final btnTextStyle;
  final btnShape;
  ButtonActiveWidget({Key key,this.data,this.btnTextStyle,this.btnShape,this.callback}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _ButtonActiveWidgetState();
  }

}
class _ButtonActiveWidgetState extends State<ButtonActiveWidget>{
  ButtonData _data;
  Color color;
  @override
  void initState(){
    // // print('init buttonactive');
    super.initState();
    _data = widget.data;
  }
  @override
  Widget build(BuildContext context) {
    // // print('build data:${_data.id},${_data.active}');
    if (_data.active == 1) {
      color = _data.activecolor!=null?_data.activecolor : Colors.blue;
    } else {
      color = _data.normalcolor;
    }
    return SizedBox(
      height: _data.height,
      width: _data.width,
      // child: Text(_data.title),
      child: RaisedButton(
        shape: widget.btnShape,
        color: color,
        child: Text(
          _data.title,
          style: widget.btnTextStyle,
        ),
        onPressed: (){
          widget.callback(_data.id);
        },
    ),
    );
  }

}

class ButtonData{
  // id
  int id;
  // 是否触发
  int active;
  // 显示的文字
  String title;
  // 未触发时颜色
  Color normalcolor;
  // 触发后颜色
  Color activecolor;
  IconData icon;
  double height;
  double width;
  Function handler;
  ButtonData({this.title,this.normalcolor,this.activecolor,this.id,this.active,this.height,this.width,this.icon,this.handler}) {
    if (this.activecolor==null) {
      this.activecolor = Colors.blue;
    }
    if (this.normalcolor==null) {
      this.normalcolor = Colors.white;
    }
    if (this.height == null) {
      this.height = 60;
    }
    if (this.width == null) {
      this.width =120;
    }
  }

}