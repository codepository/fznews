import 'package:flutter/cupertino.dart';

class PieData {
  String title;
  List<String> legend;
  List<PieItem> data;
  PieData(){
    legend = List();
    data = List();
  }
}
class PieItem {
  var value;
  var name;
  PieItem({@required this.name,@required this.value}):assert(name!=null,value!=null);
  Map toJson(){
    Map map=Map();
    map["value"] = this.value;
    map["name"] = this.name;
    return map;
  }
}