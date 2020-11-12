import 'package:flutter/material.dart';
import 'package:fznews/http/user_api.dart';

class DepartmentWidget extends StatefulWidget{
  final List<Department> data;
  DepartmentWidget({Key key,this.data}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _DepartmentWidgetState();
  }

}
class _DepartmentWidgetState extends State<DepartmentWidget>{
  List<Department> _data;
  @override void initState(){
    super.initState();
    _data=widget.data;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(_data[0].children[0].name),
    );
  }
}

