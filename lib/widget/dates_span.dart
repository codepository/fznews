import 'package:flutter/material.dart';
import 'package:fznews/widget/dates_picker.dart';

class DatesSpanWidget extends StatefulWidget{
  final TextEditingController begin;
  final TextEditingController end;
  final callback;
  final bool singleRow;
  DatesSpanWidget({Key key, this.begin,this.end,this.callback,this.singleRow}):super(key:key);
  @override
  State<StatefulWidget> createState() {

    return _DatesSpanWidgetState();
  }

}
class _DatesSpanWidgetState extends State<DatesSpanWidget> {
  TextEditingController _begin;
  TextEditingController _end;
  List<Widget> _list;
  @override
  void dispose(){
    super.dispose();
    _begin.dispose();
    _end.dispose();
  }
  @override
  void initState(){
    super.initState();
    _begin=widget.begin;
    if (_begin==null) _begin=TextEditingController();
    _end=widget.end;
    if (_end==null) _end=TextEditingController();
    _list=<Widget>[
          DatesPicker(
            helperText: "开始日期",
            textEditingController: _begin,
            callback: (val){
              this._begin.text=val;
              widget.callback({"start": _begin.text,"end": _end.text});
            },
          ), 
          DatesPicker(
            helperText: "结束日期",
            textEditingController: _end,
            callback: (val){
              this._end.text=val;
              widget.callback({"start": _begin.text,"end": _end.text});
            },
          ), 
      ];
  }
  @override
  Widget build(BuildContext context) {
    // print('build dates_span');
    return Container(
      constraints: BoxConstraints(
        maxHeight: 150
      ),
      child: widget.singleRow?Row(
        children: _list,
      ):Column(
        children: _list,
      ),
    );
  }
  
}