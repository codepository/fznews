import 'package:flutter/material.dart';
import 'package:fznews/http/user_api.dart';
// 添加新的标签
class AddLabelsWidget extends StatelessWidget{
  void addLabel(BuildContext context,String labelname,labeltype,describe){
    UserAPI.addLabel(labelname,labeltype,describe).then((data){
      if (data["status"]==200) {
        Navigator.pop(context);
      }else{
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(data["message"]),));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey=GlobalKey<FormState>();
    TextEditingController nameTEC=TextEditingController();
    TextEditingController typeTEC=TextEditingController();
    TextEditingController describeTEC=TextEditingController();
    
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
                    "添加新标签",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
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
                      controller: nameTEC,
                      decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key),
                        hintText: '名称',
                        labelText: '名称',
                      ),
                      validator: (value){
                        if (value.isEmpty) return '请输入名称';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: typeTEC,
                      decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key),
                        hintText: '标签类型',
                        labelText: '类型',
                      ),
                      validator: (value){
                        if (value.isEmpty) return '请输入类型';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: describeTEC,
                      decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key),
                        hintText: '标签的有什么作用',
                        labelText: '描述',
                      ),
                      validator: (value){
                        if (value.isEmpty) return '请输入描述';
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
                    addLabel(context,nameTEC.text,typeTEC.text,describeTEC.text);
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