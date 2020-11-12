import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/http/user_api.dart';
import 'package:fznews/routes.dart';
import 'package:fznews/tongji/model/tongji_model.dart';


class AlterPasswordWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _AlterPasswordWidgetState();
  }
  
}

class _AlterPasswordWidgetState extends State<AlterPasswordWidget>{
  GlobalKey<FormState> _formKey;
  TextEditingController newTEC;
  @override void dispose(){
    super.dispose();
    newTEC.dispose();
  }
  @override void initState(){
     super.initState();
    _formKey=GlobalKey<FormState>();
    newTEC=TextEditingController();
  }
  void _alterPassword(){
    UserAPI.alterPassword(App.userinfos.token,newTEC.text).then((data){
      if (data["status"]==200){
        Tongji tj=Tongji.fromJson(data["message"]);
        App.setToken(tj.header.token);
        // print("new token:${tj.header.token},app.token:${App.userinfos.token}");
        
        App.router.navigateTo(context,Routes.Home);
        
      }else{
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(data["message"]),));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        height: double.infinity,
        alignment: Alignment(0,0),
        child: Container(
          width: 300,
          height: 400,
          child: Column(
          children: <Widget>[
              Container(
                alignment: Alignment(-1,-1),   
                child: Container(  
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle
                    ),
                    child: IconButton(
                    color: Colors.yellow,
                    icon: Icon(Icons.arrow_back,size: 30,),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment(-1,-1),
                child: Container(
                  child: Text(
                    "修改密码",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                  ),
                ),

              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: newTEC,
                      decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key),
                        hintText: '新密码',
                        labelText: '新密码',
                      ),
                      validator: (value){
                        if (value.isEmpty) return '请输入新密码';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              MaterialButton(
                color: Colors.blue,
                child: Text('确定'),
                minWidth: double.infinity,
                onPressed: (){
                  if(_formKey.currentState.validate()){
                    _alterPassword();
                  }
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}