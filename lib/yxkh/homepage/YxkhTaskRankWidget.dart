import 'package:flutter/material.dart';
import 'package:fznews/widget/DottedLine.dart';
import 'package:fznews/yxkh/bloc/homepageBloc.dart';

// YxkhTaskRankWidget 用户审批任务数和未审批任务数排行
class YxkhTaskRankWidget extends StatelessWidget {
  final HomePageBlocImpl bloc;
  YxkhTaskRankWidget({this.bloc}) : assert(bloc != null);
  @override
  Widget build(BuildContext context) {
    double ele = 45.0;
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: ele,
            width: 300,
            alignment: Alignment.center,
            color: Colors.blue,
            child: Text(
              '月任务审批排行',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Container(
              color: Colors.grey[100],
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: StreamBuilder<List<dynamic>>(
                      stream: bloc.taskRankStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.data.isEmpty) {
                          return Center(
                            child: Text("没找到数据"),
                          );
                        }
                        var data = snapshot.data;
                        return Container(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: data[0].length,
                            separatorBuilder: (context, index) {
                              return DottedLine(
                                color: Colors.grey,
                                width: 2,
                              );
                            },
                            itemBuilder: (context, index) {
                              return Container(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(data[0][index]["Avatar"]),
                                  ),
                                  title: Text(
                                    "${data[0][index]['Name']}",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "未审:${data[0][index]['Count']}",
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: StreamBuilder<List<dynamic>>(
                      stream: bloc.taskRankStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.data.isEmpty) {
                          return Center(
                            child: Text("没找到数据"),
                          );
                        }
                        var data = snapshot.data;
                        return Container(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: data[1].length,
                            separatorBuilder: (context, index) {
                              return DottedLine(
                                color: Colors.grey,
                                width: 2,
                              );
                            },
                            itemBuilder: (context, index) {
                              return Container(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(data[1][index]["Avatar"]),
                                  ),
                                  title: Text(
                                    "${data[1][index]['Name']}",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "已审:${data[1][index]['Count']}",
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
