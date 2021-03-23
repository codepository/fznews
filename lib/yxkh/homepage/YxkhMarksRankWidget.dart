import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/yxkh/bloc/homepageBloc.dart';
import 'package:fznews/yxkh/marks_rank_table.dart';
import 'package:fznews/yxkh/marks_table.dart';

// YxkhMarksRankWidget 一线考核加减分排行
class YxkhMarksRankWidget extends StatelessWidget {
  final HomePageBlocImpl bloc;
  YxkhMarksRankWidget({this.bloc}) : assert(bloc != null);
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    int year = now.year;
    if (now.month < 3) {
      year--;
    }
    return Container(
        child: StreamBuilder<List<dynamic>>(
      stream: bloc.marksRankStream,
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
        var data = snapshot.data;
        return Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: Colors.grey))),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 20,
                    width: 12,
                    color: Colors.blue[400],
                    margin: EdgeInsets.only(right: 5),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('中层干部$year年一线考核加减分排行（累计）',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue[800])),
                  ),
                  SearchMoreMarksRankWidget(
                    startDate: data[3][0],
                    endDate: data[3][1],
                    level: "1,2",
                  ),
                ],
              ),
            ),
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: MarksRankBoxWidget(
                      size: 5,
                      title: "第一考核组（日报）",
                      data: data[0][1],
                      startDate: data[3][0],
                      endDate: data[3][1],
                    )),
                Expanded(
                    flex: 1,
                    child: MarksRankBoxWidget(
                      size: 5,
                      title: "第二考核组（晚报）",
                      data: data[0][2],
                      startDate: data[3][0],
                      endDate: data[3][1],
                    )),
                Expanded(
                    flex: 1,
                    child: MarksRankBoxWidget(
                      size: 5,
                      title: "第三考核组（新媒体）",
                      data: data[0][0],
                      startDate: data[3][0],
                      endDate: data[3][1],
                    )),
                Expanded(
                    flex: 1,
                    child: MarksRankBoxWidget(
                      size: 5,
                      title: "第四考核组（社直）",
                      data: data[0][3],
                      startDate: data[3][0],
                      endDate: data[3][1],
                    )),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10, top: 20),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: Colors.grey))),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 20,
                    width: 12,
                    color: Colors.blue[400],
                    margin: EdgeInsets.only(right: 5),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('项目舞台负责人$year年一线考核加减分排行（累计）',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue[800])),
                  ),
                  SearchMoreMarksRankWidget(
                    startDate: data[3][0],
                    endDate: data[3][1],
                    tags: "项目舞台",
                  )
                ],
              ),
            ),
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: MarksRankBoxWidget(
                      size: 5,
                      title: "第一考核组（日报）",
                      data: data[0][9],
                    )),
                Expanded(
                    flex: 1,
                    child: MarksRankBoxWidget(
                      size: 5,
                      title: "第二考核组（晚报）",
                      data: data[0][10],
                      startDate: data[3][0],
                      endDate: data[3][1],
                    )),
                Expanded(
                    flex: 1,
                    child: MarksRankBoxWidget(
                      size: 5,
                      title: "第三考核组（新媒体）",
                      data: data[0][8],
                      startDate: data[3][0],
                      endDate: data[3][1],
                    )),
                Expanded(
                    flex: 1,
                    child: MarksRankBoxWidget(
                      size: 5,
                      title: "第四考核组（社直）",
                      data: data[0][11],
                      startDate: data[3][0],
                      endDate: data[3][1],
                    )),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10, top: 20),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: Colors.grey))),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 20,
                    width: 12,
                    color: Colors.blue[400],
                    margin: EdgeInsets.only(right: 5),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '工作人员$year年一线考核加减分排行（累计）',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue[800]),
                    ),
                  ),
                  SearchMoreMarksRankWidget(startDate: data[3][0], endDate: data[3][1], level: "0"),
                ],
              ),
            ),
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: MarksRankBoxWidget(
                      size: 10,
                      title: "第一考核组（日报）",
                      data: data[0][5],
                      startDate: data[3][0],
                      endDate: data[3][1],
                    )),
                Expanded(
                    flex: 1,
                    child: MarksRankBoxWidget(
                      size: 10,
                      title: "第二考核组（晚报）",
                      data: data[0][6],
                      startDate: data[3][0],
                      endDate: data[3][1],
                    )),
                Expanded(
                    flex: 1,
                    child: MarksRankBoxWidget(
                      size: 10,
                      title: "第三考核组（新媒体）",
                      data: data[0][4],
                      startDate: data[3][0],
                      endDate: data[3][1],
                    )),
                Expanded(
                    flex: 1,
                    child: MarksRankBoxWidget(
                      size: 10,
                      title: "第四考核组（社直）",
                      data: data[0][7],
                      startDate: data[3][0],
                      endDate: data[3][1],
                    )),
              ],
            )
          ],
        );
      },
    ));
  }
}

class SearchMoreMarksRankWidget extends StatelessWidget {
  final String startDate;
  final String endDate;
  final String level;
  final String tags;
  final String group;
  SearchMoreMarksRankWidget({this.startDate, this.endDate, this.level, this.tags, this.group});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: GestureDetector(
        child: Text(
          "》》更多",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        onTap: () {
          App.showAlertDialog(
              context,
              Text("加减分排行"),
              MarksRankTable(
                  params: {"startDate": startDate, "endDate": endDate, "group": group, "level": level, "tags": tags}));
        },
      ),
    );
  }
}

class MarksRankBoxWidget extends StatelessWidget {
  final String title;
  final int size;
  final List<dynamic> data;
  final double width;
  final String startDate;
  final String endDate;
  MarksRankBoxWidget({this.title, this.size, this.data, this.width, this.startDate, this.endDate})
      : assert(title != null, size != 0);
  @override
  Widget build(BuildContext context) {
    double ele = 40.0;
    double height = (size + 1) * ele;
    double _width = width ?? 100;
    return Container(
      height: height + 2,
      width: _width,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: ele,
            child: Text(title),
          ),
          Container(
            height: height - ele,
            child: ListView.builder(
              itemCount: size,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  width: _width,
                  decoration: BoxDecoration(border: Border(top: BorderSide())),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                            height: ele,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(right: BorderSide(color: Colors.black)),
                            ),
                            child: GestureDetector(
                              child: Text(
                                "${(data.length - 1) >= index ? data[index]["username"] : ""}",
                                style: TextStyle(color: Colors.blue[800]),
                              ),
                              onTap: () {
                                App.showAlertDialog(
                                    context,
                                    Text("加减分明细"),
                                    MarksTableWidget(params: {
                                      "userId": data[index]["userId"],
                                      "startDate": startDate,
                                      "endDate": endDate
                                    }));
                              },
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: ele,
                          alignment: Alignment.center,
                          child: Text("${(data.length - 1) >= index ? data[index]["markNumber"] : ""}"),
                        ),
                      ),
                    ],
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
