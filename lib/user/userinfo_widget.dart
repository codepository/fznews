import 'package:flutter/material.dart';
import 'package:fznews/user/userinfo_card.dart';
import 'package:fznews/widget/app/app_basic.dart';

class UserinfoWidget extends StatefulWidget {
  final params;
  UserinfoWidget({Key key, this.params}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _UserinfoWidgetState();
  }
}

class _UserinfoWidgetState extends State<UserinfoWidget> {
  var _params;
  String userid;
  String wxuserid;
  List<dynamic> userinfo;
  @override
  void initState() {
    super.initState();
    _params = widget.params;
    userid = _params["userid"]?.first;
    wxuserid = _params["wxuserid"]?.first;
  }

  @override
  Widget build(BuildContext context) {
    return BasicApp(
      title: Text("用户信息"),
      body: UserinfoCard(
        userid: userid,
        wxuserid: wxuserid,
      ),
      refreshBody: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
