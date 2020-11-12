import 'package:flutter/material.dart';
import 'package:fznews/widget/textfield/normal.dart';
// DingDingLogin 钉钉登陆样式
class DingDingLogin extends StatefulWidget{
  final params;
  final String welcome;
  final login;
  final forget;
  DingDingLogin({Key key,this.params,this.welcome,
    this.login,this.forget
    }):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _DingDingLoginStates();
  }

}
class _DingDingLoginStates extends State<DingDingLogin>{
  String _welcome;
  TextEditingController _accountTEC;
  TextEditingController _passwordTEC;
  GlobalKey<FormState> _formKey;
  @override
  void dispose(){
    super.dispose();
    _accountTEC.dispose();
    _passwordTEC.dispose();
  }
  @override
  void initState(){
    super.initState();
    _formKey=GlobalKey<FormState>();
    _welcome=widget.welcome!=null?widget.welcome:"欢迎使用";
    _accountTEC=TextEditingController();
    _passwordTEC=TextEditingController();
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
                    _welcome,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                  ),
                ),

              ),
              SizedBox(
                height: 10,
              ),
              // TextFieldNormal(
              //   labelText: "账号",
              //   helperText: "姓名/手机号/邮箱",
              //   textEditingController: _accountTEC,
              //   icon: Icon(Icons.child_care),
              // ),
              // TextFieldNormal(
              //   labelText: "密码",
              //   helperText: "请输入密码",
              //   textEditingController: _passwordTEC,
              //   icon: Icon(Icons.vpn_key),
              // ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      
                      controller: _accountTEC,
                      decoration: InputDecoration(
                        icon: Icon(Icons.sentiment_satisfied),
                        hintText: '姓名/手机号/邮箱',
                        labelText: '账号',
                      ),
                      validator: (value){
                        if (value.isEmpty) return '请输入账号';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordTEC,
                      obscureText: true,
                      decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key),
                        hintText: '请输入密码',
                        labelText: '密码',
                      ),
                      validator: (value){
                        if (value.isEmpty) return '请输入密码';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              MaterialButton(
                color: Colors.blue,
                child: Text('登陆'),
                minWidth: double.infinity,
                onPressed: (){
                  if (widget.login!=null){
                    if (_formKey.currentState.validate()){
                      widget.login({"account":_accountTEC.text,"password":_passwordTEC.text});
                    }
                    
                  }
                },
              ),
              Container(
                alignment: Alignment(-1,-1),
                child: GestureDetector(
                  onTap: (){
                    if(widget.forget!=null){
                      widget.forget();
                    }
                  },
                  child: Text('忘记密码'),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}