import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/http/user_api.dart';
import 'package:fznews/layout/appContainer.dart';
import 'package:fznews/routes.dart';
import 'package:fznews/tongji/model/tongji_model.dart';
import 'package:fznews/widget/login/DingDingLogin.dart';

class LoginWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginWidgetState();
  }
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  void initState() {
    super.initState();
    App.setToken(null);
  }

  @override
  Widget build(BuildContext context) {
    return DingDingLogin(
      login: (val) async {
        UserAPI.login(val).then((data) {
          if (data["status"] == 200) {
            var tj = Tongji.fromJson(data["message"]);
            App.userinfos = Userinfos.fromTongji(tj);
            App.setToken(App.userinfos.token);
            // print("登陆后:token:${prefs.getString("token")}");
            // App.router.navigateTo(context,Routes.Home);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return AppContainer();
              },
            ));
          } else {
            App.showAlertError(context, data["message"]);
          }
        });
      },
      forget: () {
        App.router.navigateTo(context, Routes.ForgetPassword);
      },
    );
  }
}
