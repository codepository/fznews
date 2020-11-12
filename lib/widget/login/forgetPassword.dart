import 'package:flutter/material.dart';
import 'package:fznews/widget/button/button_countdown.dart';
import 'package:fznews/widget/textfield/normal.dart';

class ForgetPasswordWidget extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _ForgetPasswordWidgetState();
  }

}
class _ForgetPasswordWidgetState extends State<ForgetPasswordWidget>{
  TextEditingController _accountTEC;
  @override
  void initState(){
    super.initState();
    _accountTEC=TextEditingController();
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
                    '找回密码',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                  ),
                ),

              ),
              SizedBox(
                height: 10,
              ),
              TextFieldNormal(
                labelText: "邮箱",
                helperText: "注册的邮箱",
                textEditingController: _accountTEC,
              ),
              ButtonCountDown(
                width: double.infinity,
                // elevation: 0,
                seconds: 5,
                callback: (){
                  // 发送邮件
                  
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}