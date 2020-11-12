import 'package:flutter/material.dart';
import 'package:fznews/http/user_api.dart';
// 过滤标签
class FilterChipGroup extends StatefulWidget{
  final List<dynamic> labels;
  final callback;
  FilterChipGroup({Key key,this.labels,this.callback}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _FilterChipGroupState();
  }

}
class _FilterChipGroupState extends State<FilterChipGroup>{
  List<int> _filters;
  List<dynamic> _labels;
  var _callback;
  @override void initState(){
    super.initState();
    _labels=widget.labels;
    _filters=[];
    _callback=widget.callback;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Wrap(
          spacing: 15,
          children: _labels.map((item){
            var x = Label.fromJson(item);
            return FilterChip(
              label: Text(x.labelname),
              selected: _filters.contains(x.labelid),
              onSelected: (v){
                setState(() {
                  if (v){
                  _filters.add(x.labelid);
                  }else{
                    _filters.removeWhere((f){
                      return f==x.labelid;
                    });
                  }
                  if (_callback!=null){
                  //  print("SELECTED:$_filters");
                  _callback(_labels.where((item)=>_filters.contains(item["id"])).toList());
                }

                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
  
}
