import 'package:flutter/material.dart';
import 'package:fznews/widget/SlideTransitionDemo.dart';

// DingDingLogin 钉钉登陆样式
class DingDingLogin extends StatefulWidget {
  final params;
  final String welcome;
  final login;
  final forget;
  DingDingLogin({Key key, this.params, this.welcome, this.login, this.forget}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DingDingLoginStates();
  }
}

class _DingDingLoginStates extends State<DingDingLogin> with SingleTickerProviderStateMixin {
  String _welcome;
  TextEditingController _accountTEC;
  TextEditingController _passwordTEC;
  GlobalKey<FormState> _formKey;
  AnimationController controller;
  Animation<double> animation;
  Animation<double> buttonZoomout;
  @override
  void dispose() {
    super.dispose();
    _accountTEC.dispose();
    _passwordTEC.dispose();
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _welcome = widget.welcome != null ? widget.welcome : "欢迎使用";
    _accountTEC = TextEditingController();
    _passwordTEC = TextEditingController();
    controller = AnimationController(duration: Duration(milliseconds: 2000), vsync: this)
      ..addListener(() {
        if (controller.isCompleted) {
          controller.reverse();
        }
      });
    animation =
        Tween(begin: 320.0, end: 65.0).animate(CurvedAnimation(parent: controller, curve: Interval(0.0, 0.250)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        alignment: Alignment(0, 0),
        child: Container(
          width: 300,
          height: 400,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment(-1, -1),
                child: Container(
                  decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  child: IconButton(
                    color: Colors.yellow,
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment(-1, -1),
                child: Container(
                  child: Text(
                    _welcome,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
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
                      controller: _accountTEC,
                      decoration: InputDecoration(
                        icon: Icon(Icons.sentiment_satisfied),
                        hintText: '姓名/手机号/邮箱',
                        labelText: '账号',
                      ),
                      validator: (value) {
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
                      validator: (value) {
                        if (value.isEmpty) return '请输入密码';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return GestureDetector(
                    child: Container(
                      width: animation.value,
                      height: 50,
                      alignment: FractionalOffset.center,
                      decoration:
                          BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: animation.value > 75.0
                          ? Text(
                              "登 陆",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300, letterSpacing: 0.3),
                            )
                          : CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                    ),
                    onTap: () {
                      controller.forward();
                      if (widget.login != null) {
                        if (_formKey.currentState.validate()) {
                          widget.login({"account": _accountTEC.text, "password": _passwordTEC.text});
                        }
                      }
                    },
                  );
                },
              ),
              Container(
                alignment: Alignment(-1, -1),
                child: GestureDetector(
                  onTap: () {
                    if (widget.forget != null) {
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
