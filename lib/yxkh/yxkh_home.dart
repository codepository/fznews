import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// YxkhHome 一线考核首页
class YxkhHome extends StatefulWidget {
  final params;
  YxkhHome({Key key, this.params}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _YxkhHomeState();
  }
}

class _YxkhHomeState extends State<YxkhHome> {
  ScrollController _scrollController;
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: NestedScrollView(
          body: Container(
            child: Text('body'),
          ),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 150,
                //是否随着滑动隐藏标题
                floating: false,
                //是否固定在顶部
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset('assets/images/top.jpg'),
                ),
              )
            ];
          },
        ),
      ),
    );
  }
}
