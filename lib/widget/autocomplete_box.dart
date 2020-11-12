import 'package:flutter/material.dart';
// AutocompleteBox 自动填充输入框
// 输入框内容变化时，提示数据更新，并在弹出下拉框中显示
// 下拉框悬浮于其它内容之上
// 点击下拉框任一项，更新输入框内容，并回收下拉框
class AutocompleteBox extends StatefulWidget {
  final TextEditingController textEditingController;
  final EdgeInsetsGeometry contentPadding;
  final labelText;
  final helperText;
  final IconData icon;
  // 输入值变化时，更新下拉框中的提示数据
  final  onchange;
  // 返回值{"id":2,"name":"张三"}
  final onsubmit;
  // 下拉框中的数据
  final datas;
  AutocompleteBox({Key key,this.textEditingController,
    this.contentPadding,this.labelText="",this.helperText="",
    this.icon=Icons.text_fields,this.onchange,this.onsubmit,
    this.datas}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _AutocompleteBoxState();
  }
  
}
class _AutocompleteBoxState extends State<AutocompleteBox> {
  ScrollController controller;
  TextEditingController textEditingController;
  var contentPadding;
  Function _onchange;
  var _onsubmit;
  bool showSuggestion=false;
  OverlayEntry _overlay;
  // 输入框
  @override void initState(){
    super.initState();
    _onchange=widget.onchange;
    _onsubmit=widget.onsubmit;
    controller=ScrollController();
    textEditingController=widget.textEditingController==null?TextEditingController():widget.textEditingController;
    // print("init autocomplete");
  }
  // 第二次变化时显示前一个结果
  void _textChanged(var str){
    // print("change $str");
    if (_onchange==null)return;
    showSuggestion=true;
    if (str.isNotEmpty){
        // print("更新值为:$str");
       _onchange(str);
    }
  }
  @override
  Widget build(BuildContext context) {
    // print("build autocomplete ${textEditingController.text}");
    WidgetsBinding.instance.addPostFrameCallback((_){
      // print("addPostFrameCallback");
     _showOverlay(showSuggestion);
    });
    return Container(
      child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              contentPadding: contentPadding!=null?contentPadding:EdgeInsets.all(3.0),
              labelText: widget.labelText,
              helperText: widget.helperText,
              icon: Icon(widget.icon)
            ),
            onChanged: _textChanged,
            autofocus: false,
          ),
    );
  }
  OverlayEntry _createSelectView(BuildContext context){
    RenderBox renderBox=context.findRenderObject();
    var parentSize=renderBox.size;
    var parentPosition=renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
      builder: (context) => Positioned(
        top: parentPosition.dy+parentSize.height,
        left: parentPosition.dx,
        width: parentSize.width,
        height: 3*parentSize.height,
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              width: parentSize.width,
              height: 3*parentSize.height,
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                children: widget.datas.map<Widget>((d)=>Container(
                    width: parentSize.width,
                    height: 20,
                    child: FlatButton(
                      child: Text(d.name,style: TextStyle(fontSize: 15,color: Colors.black),),
                      onPressed: (){
                        // print("tab");
                        textEditingController.text=d.name;
                        if(_onsubmit!=null) _onsubmit(d);
                         showSuggestion=false;
                        _showOverlay(showSuggestion);
                      },
                    ),
                )).toList(),
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  _showOverlay(bool isShow){
    if (isShow){
      // print("弹出下拉框");
      if (widget.datas==null) return;
      // print("_ovlerlay==null?:${_overlay==null}");
      if (_overlay!=null){
        // print("overlay不为空，先移除里面的元素");
        _overlay?.remove();
      }
      _overlay=_createSelectView(context);
      Overlay.of(context).insert(_overlay);
    }else{
      // print("收起下拉框");
      // print("_ovlerlay==null?:${_overlay==null}");
      if(_overlay==null)return;
      _overlay?.remove();
      _overlay=null;
    }
  }
}

