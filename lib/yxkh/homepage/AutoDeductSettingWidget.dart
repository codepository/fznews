import 'package:flutter/material.dart';
import 'package:fznews/http/response_data.dart';
import 'package:fznews/http/yxkh_api.dart';

import '../../app.dart';

class AutoDeductSettingWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AutoDeductSettingWidgetState();
  }
}

class _AutoDeductSettingWidgetState extends State<AutoDeductSettingWidget> {
  List<dynamic> dics;
  TextEditingController valTec;
  TextEditingController desriptionTec;
  @override
  void initState() {
    getDatas();
    valTec = TextEditingController();
    desriptionTec = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    valTec.dispose();
    desriptionTec.dispose();
    super.dispose();
  }

  void getDatas() {
    dics = List();
    YXKHAPI.findAllDict({"type": "月考自动加减分"}).then((data) {
      if (data["status"] != 200) {
        App.showAlertError(context, data["message"]);
        return;
      }
      var datas = ResponseData.fromResponse(data);
      dics.addAll(datas[0]);
      setState(() {});
    });
    YXKHAPI.findAllDict({"type": "月度考核"}).then((data) {
      if (data["status"] != 200) {
        App.showAlertError(context, data["message"]);
        return;
      }
      var datas = ResponseData.fromResponse(data);
      dics.addAll(datas[0]);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 50 + dics.length * 50.0,
      child: ListView.builder(
        itemCount: dics.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
            child: ListTile(
              title: Text("${dics[index]["name"]}:${dics[index]["value"]}"),
              leading: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  valTec.text = "${dics[index]["value"]}";
                  desriptionTec.text = "${dics[index]["description"] ?? "暂无"}";
                  App.showAlertDialog(
                      context,
                      Text(""),
                      Container(
                        width: 350,
                        height: 200,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("值修改:"),
                            TextField(
                              controller: valTec,
                            ),
                            Text("作用描述:"),
                            TextField(
                              controller: desriptionTec,
                            ),
                          ],
                        ),
                      ), callback: () {
                    dics[index]["value"] = valTec.text;
                    dics[index]["description"] = desriptionTec.text;
                    YXKHAPI.updateDict(dics[index]).then((data) {
                      if (data["status"] != 200) {
                        App.showAlertInfo(context, data["message"]);
                        return;
                      }
                      setState(() {});
                    });
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
