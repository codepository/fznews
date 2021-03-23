import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/http/user_api.dart';
import 'package:fznews/widget/DottedLine.dart';
import 'package:fznews/yxkh/bloc/homepageBloc.dart';
import 'package:popup_menu/popup_menu.dart';

// YxkhRemarksWidget 一线考核嘉奖通报
class YxkhRemarksWidget extends StatelessWidget {
  final HomePageBlocImpl bloc;

  YxkhRemarksWidget({this.bloc});
  Widget _buildtitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 20,
          child: IconButton(
            tooltip: "添加文件",
            color: Colors.blue[900],
            padding: EdgeInsets.all(0),
            icon: Icon(Icons.add_box),
            onPressed: () async {
              if (App.hasAuthority(context, "考核办")) {
                var data = await UserAPI.saveFileToDB("remarks");
                bloc.onAddRemarksFile();
                // 更新显示的数据
                App.showAlertInfo(context, data);
              }
            },
          ),
        ),
        Container(
          width: 35,
          child: IconButton(
            tooltip: "上一页",
            color: Colors.blue[900],
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              bloc.prePageRemarksFile();
            },
          ),
        ),
        Container(
          child: Text(
            '一线考核嘉奖通报',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        Container(
          width: 35,
          child: IconButton(
            tooltip: "下一页",
            color: Colors.blue[900],
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              // print("下一页,查询文件");
              this.bloc.nextPageRemarksFile();
            },
          ),
        ),
        Container(
          width: 35,
          child: IconButton(
            tooltip: "搜索",
            color: Colors.blue[900],
            icon: Icon(Icons.search),
            onPressed: () {
              App.showAlertDialog(
                  context,
                  Text("搜索文件"),
                  Container(
                    width: 100,
                    height: 100,
                    child: TextField(
                      controller: TextEditingController(text: bloc.remarksFilename ?? ""),
                      onChanged: (val) {
                        bloc.remarksFilename = val;
                      },
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(10), hintText: "文件名搜索"),
                    ),
                  ), callback: () {
                bloc.onSearchRemarksFile();
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double ele = 45.0;
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: ele,
            color: Colors.blue,
            child: _buildtitle(context),
          ),
          Container(
              color: Colors.grey[100],
              child: StreamBuilder<List<dynamic>>(
                stream: bloc.remarksFileStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data.isEmpty) {
                    return Center(
                      child: Text("没有找到数据"),
                    );
                  }
                  return Container(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      separatorBuilder: (context, index) {
                        return DottedLine(
                          color: Colors.grey,
                          width: 2,
                        );
                      },
                      itemBuilder: (context, index) {
                        Key key = GlobalKey();
                        return Container(
                          padding: EdgeInsets.all(15),
                          child: GestureDetector(
                            key: key,
                            child: Text(
                              "${snapshot.data[index]['filename']}",
                              style: TextStyle(color: Colors.blue[800]),
                            ),
                            onTap: () {
                              PopupMenu menu = PopupMenu(
                                backgroundColor: Colors.blue[800],
                                lineColor: Colors.tealAccent,
                                // maxColumn: 3,
                                items: [
                                  MenuItem(
                                      title: '下载',
                                      textStyle: TextStyle(fontSize: 10.0, color: Colors.tealAccent),
                                      image: Icon(
                                        Icons.arrow_downward,
                                        color: Colors.white,
                                      )),
                                  MenuItem(
                                      title: '删除',
                                      image: Icon(
                                        Icons.delete_forever,
                                        color: Colors.white,
                                      )),
                                  MenuItem(
                                      title: snapshot.data[index]['username'] ?? "",
                                      image: Icon(
                                        Icons.people,
                                        color: Colors.white,
                                      )),
                                ],
                                onClickMenu: (item) {
                                  switch (item.menuTitle) {
                                    case "下载":
                                      UserAPI.downloadFileFromdb(snapshot.data[index]['id'],
                                          filename: snapshot.data[index]['filename']);
                                      break;
                                    case "删除":
                                      // 只有考核办和本人才能删除
                                      if (App.hasAuthority(context, "考核办") ||
                                          App.userinfos.user.id == snapshot.data[index]['uid']) {
                                        bloc.onDelRemarksFile(snapshot.data[index]);
                                        return;
                                      }

                                      break;
                                    default:
                                  }
                                },
                                // onDismiss: onDismiss
                              );
                              PopupMenu.context = context;
                              menu.show(widgetKey: key);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}
