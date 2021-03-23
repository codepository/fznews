import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fznews/http/tongji_api.dart';
import 'package:fznews/routes.dart';
import 'package:fznews/tongji/editor_flow_rank.dart';
import 'package:fznews/tongji/model/tongji_model.dart';
import 'package:fznews/utils/screenUtil.dart';
import 'package:fznews/widget/button_group.dart';
import 'package:fznews/widget/dates_span.dart';
import 'package:fznews/widget/editor_flow_card.dart';
import 'package:fznews/widget/tabbar_card.dart';
import 'dart:math' as math;

import 'package:fznews/widget/textfield/normal.dart';

// 用户流量统计
class EditorFlow extends StatefulWidget {
  final params;
  EditorFlow({Key key, this.params}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return EditorFlowState();
  }
}

class EditorFlowState extends State<EditorFlow> with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  List<dynamic> dataList;
  Tongji params = Tongji();
  int pageNumber;
  bool isLoading = false;
  bool noMore = false;
  List<TabItem> tabs;
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    dataList.clear();
  }

  @override
  void initState() {
    super.initState();
    dataList = List();
    _scrollController = new ScrollController();
    pageNumber = 1;
    setParams();
    this._getMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50) {
        _getMoreData();
      }
    });
    tabs = [TabItem("今天"), TabItem("昨天"), TabItem("最近7天"), TabItem("最近30天")];
  }

  void setParams() {
    params.body.method = "visit/editor/flowWithAvators";
    params.body.startDate = '${DateTime.now().subtract(Duration(days: 1))}'.substring(0, 10);
    params.body.maxResults = 50;
    params.body.startIndex = 0;
    params.body.total = 0;
  }

  void resetData() {
    params.body.startIndex = 0;
    params.body.total = 0;
    pageNumber = 1;
    dataList.clear();
  }

  void _download() async {
    TongjiAPI.download(params.toJson());
  }

  void _getMoreData() async {
    // // print('nomore: $noMore,isloading:$isLoading');
    if (noMore) {
      return;
    }
    // print("params:${params.toJson()}");
    if (params.body.startIndex != 0 &&
        (params.body.total <= dataList.length || params.body.startIndex >= params.body.total)) {
      noMore = true;
      return;
    }

    if (!isLoading) {
      isLoading = true;
      // 这里不能更新状态

      this.params.body.startIndex = (this.pageNumber - 1) * this.params.body.maxResults;
      this.pageNumber++;
      TongjiAPI.getData(params.toJson()).then((data) {
        if (data["status"] != 200) {
          return;
        }
        var result = Tongji.fromJson(data["message"]);
        params.body.total = result.body.total;
        // // print(data[0]);
        setState(() {
          isLoading = false;
          if (result.body.data != null) dataList.addAll(result.body.data[0]);
        });
      });
    }
  }

  double getChildAspectRatio(BuildContext context) {
    double rowHeight = 120;
    double mediawidth = ScreenUtils.screenW(context);
    if (mediawidth > 800) {
      return 800 / rowHeight;
    }
    if (mediawidth > 600) {
      rowHeight = 180;
      return 800 / rowHeight;
    }
    if (mediawidth > 400) {
      rowHeight = 200;
      return 800 / rowHeight;
    }
    rowHeight = 180;
    return mediawidth / rowHeight;
  }

  @override
  Widget build(BuildContext context) {
    // print("build editorFlowState");
    return Center(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: EdgeInsets.all(10.0),
          //     child: Text(
          //     '流量榜单',
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 20.0,
          //       fontWeight: FontWeight.bold
          //     ),
          //   ),
          //   ),
          // ),
          // EditorFlowRankSliverGrid(),
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              maxHeight: 80,
              minHeight: 80,
              child: Container(
                // padding: EdgeInsets.fromLTRB(0,10,0,0),
                child: ESearchBoxWidget(callback: (val) {
                  if (val != null) {
                    switch (val["method"]) {
                      case "export/editor/flowAndManuscriptNumLastMonth":
                        params.body.method = val["method"];
                        _download();
                        break;
                      case "export/editor/flowAndManuscriptNum":
                        params.body.method = val["method"];
                        params.body.startDate = val["start"];
                        params.body.endDate = val["end"];
                        params.body.maxResults = null;
                        _download();
                        break;
                      default:
                        params.body.method = "visit/editor/flowWithAvators";
                        params.body.startDate = val["start"];
                        params.body.endDate = val["end"];
                        params.body.maxResults = 50;
                        resetData();
                        setState(() {});
                        _getMoreData();
                    }
                  }
                }),
              ),
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return Center(
                child: EditorFlowCard(
                  route: '${Routes.Editor_Detail}?username=${dataList[index]["username"]}',
                  avatar: dataList[index]["avatar"],
                  title: '${dataList[index]["realname"]}/ ${dataList[index]["username"]}',
                  subtitle: "流量: ${dataList[index]["pv_count"]} /访客数${dataList[index]["visitor_count"]}",
                  star: dataList[index]["star"],
                ),
              );
            }, childCount: dataList.length),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 800,
              crossAxisSpacing: 10.0,
              childAspectRatio: getChildAspectRatio(context),
            ),
          ),
        ],
      ),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}

class ESearchBoxWidget extends StatefulWidget {
  final callback;
  ESearchBoxWidget({Key key, this.callback}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ESearchBoxWidgetState();
  }
}

class _ESearchBoxWidgetState extends State<ESearchBoxWidget> with TickerProviderStateMixin {
  String start;
  String end;
  var _data;
  var callback;
  var beginDate = TextEditingController();
  var endDate = TextEditingController();
  List<ButtonData> btns;
  List<RouteHandler> _tabs;
  TabController _tabsController;
  ButtonGroupWidget btngroup;
  @override
  void dispose() {
    super.dispose();
    _tabsController.dispose();
  }

  @override
  void initState() {
    super.initState();
    callback = widget.callback;
    _tabs = <RouteHandler>[
      RouteHandler(
          title: '昨天',
          icon: Icons.directions_bike,
          handler: ({Map<String, dynamic> params}) {
            start = '${DateTime.now().subtract(Duration(days: 1))}'.substring(0, 10);
            end = start;
            callback({"start": start, "end": end});
          }),
      RouteHandler(
          title: '最近7天',
          icon: Icons.directions_boat,
          handler: ({Map<String, dynamic> params}) {
            start = '${DateTime.now().subtract(Duration(days: 6))}'.substring(0, 10);
            end = '${DateTime.now()}'.substring(0, 10);
            callback({"start": start, "end": end});
          }),
      RouteHandler(
          title: '最近30天',
          icon: Icons.directions_bus,
          handler: ({Map<String, dynamic> params}) {
            start = '${DateTime.now().subtract(Duration(days: 29))}'.substring(0, 10);
            end = '${DateTime.now()}'.substring(0, 10);
            callback({"start": start, "end": end});
          }),
      RouteHandler(
          title: '自定义',
          icon: Icons.directions_bus,
          handler: ({Map<String, dynamic> params}) {
            showAlertDialog();
          }),
      RouteHandler(
          title: '导出',
          icon: Icons.directions_bus,
          handler: ({Map<String, dynamic> params}) {
            // callback({"method":"export/editor/flowAndManuscriptNumLastMonth"});
            showExportDialog();
          }),
      RouteHandler(
          title: '导出上月',
          icon: Icons.directions_bus,
          handler: ({Map<String, dynamic> params}) {
            callback({"method": "export/editor/flowAndManuscriptNumLastMonth"});
          }),
    ];
    _tabsController = TabController(length: _tabs.length, vsync: this);
  }

  void showExportDialog() {
    TextEditingController begin = TextEditingController();
    TextEditingController end = TextEditingController();
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('自定义日期'),
          content: Column(
            children: <Widget>[
              TextFieldNormal(
                labelText: '开始日期',
                helperText: '格式：2020-05-06',
                textEditingController: begin,
              ),
              TextFieldNormal(
                labelText: '结束日期',
                helperText: '格式：2020-05-06',
                textEditingController: end,
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
                callback({"method": "export/editor/flowAndManuscriptNum", "start": begin.text, "end": end.text});
              },
            ),
          ],
        );
      },
    );
  }

  void showAlertDialog() {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('自定义日期'),
          content: DatesSpanWidget(
            singleRow: false,
            callback: (data) {
              _data = data;
            },
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
                callback(_data);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // child: Column(
      //   children: <Widget>[
      //       btngroup,
      //   ],
      // ),
      child: TabBar(
        isScrollable: true,
        controller: _tabsController,
        indicatorColor: Color.fromARGB(255, 45, 45, 45),
        labelColor: Color.fromARGB(255, 45, 45, 45),
        labelStyle: TextStyle(fontSize: 15, color: Color.fromARGB(255, 45, 45, 45), fontWeight: FontWeight.bold),
        unselectedLabelColor: Color.fromARGB(255, 135, 135, 135),
        unselectedLabelStyle: TextStyle(fontSize: 15, color: Color.fromARGB(255, 135, 135, 135)),
        indicatorSize: TabBarIndicatorSize.label,
        tabs: _tabs.map((RouteHandler choice) {
          return Tab(
            text: choice.title,
          );
        }).toList(),
        onTap: (index) {
          _tabs[index].handler();
        },
      ),
    );
  }
}
