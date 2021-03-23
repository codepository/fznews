import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fznews/utils/screenUtil.dart';
import 'package:fznews/widget/icon_button_countdown.dart';
import 'package:fznews/widget/wheel_switch.dart';
import 'package:fznews/yxkh/bloc/YxkhMarksPrincipleBloc.dart';
import 'package:fznews/yxkh/bloc/homepageBloc.dart';
import 'package:fznews/yxkh/homepage/YxkhMarksPrincipleWidget.dart';
import 'package:fznews/yxkh/homepage/YxkhMarksRankWidget.dart';
import 'package:fznews/yxkh/homepage/YxkhPersonUnApply.dart';
import 'package:fznews/yxkh/homepage/YxkhPublicWidget.dart';
import 'package:fznews/yxkh/homepage/YxkhRemarksWidget.dart';
import 'package:fznews/yxkh/homepage/YxkhTaskRankWidget.dart';
import 'package:fznews/yxkh/homepage/YxkhYearRanksWidget.dart';
import 'package:fznews/yxkh/homepage/yxkhCompleteDescribeWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app.dart';

class HomePage extends StatefulWidget {
  final params;
  HomePage({Key key, this.params});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  HomePageBlocImpl bloc;
  YxkhMarksPrincipleBlocImpl marksPrincipleBloc;
  List<dynamic> homedatas;
  List<dynamic> taskRank = List();
  List<dynamic> marksRank = List();
  List<dynamic> publicFile = List();
  // 未审批任务排行显示开关
  bool _taskRankVisible = true;
  // 未交月度考核任务清单
  bool _uncommittedVisible = true;
  AnimationController animationController;
  Animation<double> animation;

  Animation<double> fadeAnimation;
  AnimationController fadeController;
  @override
  void dispose() {
    animationController.dispose();
    fadeController.dispose();
    super.dispose();
    bloc.dispose();
    marksPrincipleBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    bloc = HomePageBlocImpl();
    marksPrincipleBloc = YxkhMarksPrincipleBlocImpl();
    // _getDatas();
    animationController = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();
    fadeController = AnimationController(duration: Duration(seconds: 1), vsync: this);
    fadeAnimation = Tween(begin: 1.0, end: 0.0).animate(fadeController);
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      App.showAlertError(context, "无法连接：$url,未开通外网");
    }
  }

  Widget _buildChild(BuildContext context) {
    double width = ScreenUtils.isXLargeScreen(context) ? 1200.0 : ScreenUtils.screenW(context);
    return Container(
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.rectangle, boxShadow: [
        BoxShadow(color: Colors.black12, offset: Offset(0.0, 15.0), blurRadius: 15.0, spreadRadius: 1.0)
      ]),
      width: width,
      alignment: Alignment.center,
      child: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          // 横幅
          SliverToBoxAdapter(
            child: Container(
              height: 150,
              width: width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                // color: Colors.blue,
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.topCenter,
                    image: AssetImage(App.ASSEST_IMG + 'top.jpg')),
              ),
            ),
          ),
          //  进入填表
          SliverToBoxAdapter(
            child: Container(
                height: 50,
                alignment: Alignment.centerLeft,
                color: Color.fromRGBO(68, 141, 186, 1),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 130,
                      alignment: Alignment.center,
                      color: Color.fromRGBO(62, 127, 168, 1),
                      child: GestureDetector(
                          child: Text(
                            "进入填表",
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          onTap: () {
                            if (App.isLogin()) {
                              _launchURL("http://129.0.97.23:30002/#/yxkhDashboard?token=${App.getToken()}");
                            } else {
                              App.router.navigateTo(context, "/login");
                            }
                          }),
                    ),
                    IconButtonCountDown(
                      icon: Icon(Icons.refresh),
                      color: Colors.white,
                      iconSize: 30,
                      onPressed: () {
                        bloc.findHomeData(refresh: true);
                      },
                    ),
                  ],
                )),
          ),
          // 月度考核提交率
          SliverToBoxAdapter(
            child: Container(
              width: width,
              height: 300,
              child: YxkhCompleteDescribeWidget(
                bloc: bloc,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Flex(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              direction: Axis.horizontal,
              children: <Widget>[
                // 左侧内容
                Expanded(
                    flex: 18,
                    child: Container(
                      margin: EdgeInsets.only(right: 30),
                      child: Column(
                        children: <Widget>[
                          // 加减分排行
                          YxkhMarksRankWidget(bloc: bloc),
                          // 年度考核
                          YxkhYearRanksWidget(bloc: bloc),
                          // 加减分细则
                          YxkhMarksPrincipleWidget(
                            bloc: marksPrincipleBloc,
                            width: width / 24 * 15,
                          ),
                        ],
                      ),
                    )),
                //  右侧边栏
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                          visible: _taskRankVisible,
                          child: Container(
                            child: YxkhTaskRankWidget(
                              bloc: bloc,
                            ),
                          )),
                      // 未提交上月一线考核
                      Visibility(
                        visible: _uncommittedVisible,
                        child: Container(
                          child: YxkhPersonUnApply(bloc: bloc),
                        ),
                      ),
                      Container(
                          child: YxkhRemarksWidget(
                        bloc: bloc,
                      )),
                      Container(
                        child: YxkhPublicWidget(
                          bloc: bloc,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: WheelSwitch(
                    value: _taskRankVisible,
                    backgroundChild: Text(
                      "审批排行",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    onChanged: (value) {
                      _taskRankVisible = !_taskRankVisible;
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: WheelSwitch(
                    value: _uncommittedVisible,
                    duration: Duration(milliseconds: 500),
                    backgroundChild: Text(
                      "未交名单",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    onChanged: (value) {
                      _uncommittedVisible = !_uncommittedVisible;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Future _getDatas() async {
  //   bloc = HomePageBlocImpl();
  // }

  @override
  Widget build(BuildContext context) {
    return bloc.hasData == true
        ? Center(
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return ClipPath(
                  clipper: CirclePath(animation.value),
                  child: _buildChild(context),
                );
              },
            ),
          )
        : FutureBuilder(
            future: bloc.getDatas(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  return Text("链接中..");
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  bloc.setHomeData(snapshot.data);
                  return Center(
                    child: AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return ClipPath(
                          clipper: CirclePath(animation.value),
                          child: _buildChild(context),
                        );
                      },
                    ),
                  );
                default:
                  return Text("网络请求未发出。。");
              }
            },
          );
  }
}

class CirclePath extends CustomClipper<Path> {
  CirclePath(this.value);

  final double value;

  @override
  Path getClip(Size size) {
    var path = Path();
    double radius = value * sqrt(size.height * size.height + size.width * size.width);
    path.addOval(Rect.fromLTRB(size.width - radius, -radius, size.width + radius, radius));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
