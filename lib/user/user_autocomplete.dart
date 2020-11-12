import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/http/user_api.dart';
import 'package:fznews/tongji/model/tongji_model.dart';
import 'package:fznews/widget/autocomplete_box.dart';

class UserAutocompleteWidget extends StatefulWidget {
  final callback;
  UserAutocompleteWidget({Key key,this.callback}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _UserAutocompleteWidgetState();
  }
  
}
class _UserAutocompleteWidgetState extends State<UserAutocompleteWidget> {
  var datas;
  var _callback;
  @override void initState(){
    super.initState();
    _callback=widget.callback;
  }
  void _onchange(val){
    this.getDatas(val);
  }
  
  void getDatas(val){
    UserAPI.getUsers(username: val).then((data){
      if (data["status"]!=200) {
        App.showAlertError(context,data["message"]);
        return;
      }
      var result=Tongji.fromJson(data["message"]);
      datas=User.fromList(result.body.data[0]);
      setState(() {
        
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return new AutocompleteBox(onsubmit: (val){
      if (_callback!=null) _callback(val);
    },onchange: _onchange,datas: datas,);
  }
  
}