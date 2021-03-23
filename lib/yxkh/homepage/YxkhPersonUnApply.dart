import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fznews/app.dart';
import 'package:fznews/http/response_data.dart';
import 'package:fznews/http/user_api.dart';
import 'package:fznews/widget/DottedLine.dart';
import 'package:fznews/widget/person_avatar_widget.dart';
import 'package:fznews/yxkh/bloc/homepageBloc.dart';
import 'package:provider/provider.dart';

// YxkhPersonUnApply 未提交上月一线考核的员工
class YxkhPersonUnApply extends StatefulWidget {
  final HomePageBlocImpl bloc;
  YxkhPersonUnApply({this.bloc}) : assert(bloc != null);
  @override
  State<StatefulWidget> createState() {
    return _YxkhPersonUnApplyState();
  }
}

class _YxkhPersonUnApplyState extends State<YxkhPersonUnApply> with SingleTickerProviderStateMixin {
  // AnimationController controller;
  bool _downlaod = false;
  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // controller = AnimationController(duration: Duration(seconds: 2), vsync: this);

    super.initState();
  }

  // void _performAnimation() {
  //   if (!mounted) return;
  //   if (_downlaod) {
  //     controller.forward();
  //   } else {
  //     controller.reverse();
  //   }
  // }

  // void _toggleChildren() {}
  @override
  Widget build(BuildContext context) {
    double ele = 45.0;
    var now = DateTime.now();
    var year = now.year;
    var month = now.month;
    if (month == 1) {
      month = 12;
      year--;
    }
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: ele,
            width: 300,
            alignment: Alignment.center,
            color: Colors.red,
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '月度考核未交清单',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: IconButton(
                      icon: Icon(Icons.file_download),
                      onPressed: () {
                        if (_downlaod) {
                          print("3秒查询一次");
                          return;
                        }
                        _downlaod = true;
                        Future.delayed(Duration(seconds: 3), () {
                          _downlaod = false;
                        });
                        UserAPI.personUnApplyByGroup(apply: 0, limit: 200, titleLike: "$year年$month月份-月度考核")
                            .then((data) {
                          if (data["status"] != 200) {
                            App.showAlertError(context, data["message"]);
                            return;
                          }
                          ResponseData rd = ResponseData.fromJson(data["message"]);
                          var fields = rd.body.fields;
                          var datas = rd.body.data;
                          List<Widget> childList = List();
                          for (var i = 0; i < fields.length; i++) {
                            StringBuffer buffer = StringBuffer();
                            datas[i].forEach((item) {
                              buffer.write(item['name'] + ",");
                            });
                            if (buffer.length > 0) {
                              childList.add(
                                UnApplyChild(
                                  title: fields[i],
                                  width: 400,
                                  height: buffer.length / 2 * 1.0 + 50,
                                  subtitle: buffer.toString(),
                                ),
                              );
                            }
                          }
                          App.showAlertDialog(
                              context,
                              Container(),
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: childList,
                                ),
                              ));
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.grey[100],
            child: StreamBuilder<List<dynamic>>(
              stream: widget.bloc.personUnApplyStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.data.isEmpty) {
                  return Center(
                    child: Text("没找到数据"),
                  );
                }
                var data = snapshot.data;
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: data.length,
                    separatorBuilder: (context, index) {
                      return DottedLine(
                        color: Colors.grey,
                        width: 2,
                      );
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Wrap(
                            children: data[index].map<Widget>((d) {
                          return PersonAvatarWidget(width: 60, height: 60, data: PersonAvatar(d["name"], d["avatar"]));
                        }).toList()),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UnApplyChild extends StatelessWidget {
  final int index;
  final double height;
  final double width;
  final Color backgroundColor;
  final double elevation;
  final Widget child;

  final bool visible;
  final VoidCallback onTap;
  final VoidCallback toggleChildren;
  final String title;
  final String subtitle;
  final Color titleColor;
  final Color subTitleColor;
  UnApplyChild(
      {Key key,
      Animation<double> animation,
      this.index,
      this.backgroundColor,
      this.elevation = 6.0,
      this.child,
      this.title,
      this.subtitle,
      this.visible = false,
      this.onTap,
      this.toggleChildren,
      this.titleColor,
      this.height,
      this.width,
      this.subTitleColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: GestureDetector(
        onTap: () {
          Clipboard.setData(ClipboardData(text: "$subtitle"));
          App.showAlertInfo(context, "复制成功");
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
          color: backgroundColor,
          child: Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.content_cut),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: titleColor ?? Colors.black, fontSize: 16.0),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          subtitle,
                          softWrap: true,
                          style: TextStyle(color: subTitleColor ?? Colors.black, fontSize: 12.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
