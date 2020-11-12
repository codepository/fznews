import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// YxkhHome 一线考核首页
class YxkhHome extends StatefulWidget{
  final params;
  YxkhHome({Key key,this.params}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _YxkhHomeState();
  }

}
class _YxkhHomeState extends State<YxkhHome>{
  ScrollController _scrollController;
  @override
  void dispose(){
    super.dispose();
    _scrollController.dispose();
  }
  @override
  void initState(){
    super.initState();
    _scrollController=new ScrollController();
  }
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          body: NestedScrollView(
            body: Container(
              child: Text('body'),
            ),
            headerSliverBuilder: (BuildContext context,bool innerBoxIsScrolled){
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 150,
                  //是否随着滑动隐藏标题
                  floating: false,
                  //是否固定在顶部
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      'assets/images/top.jpg'
                    ),
                  ),
                )
              ];
            },
          ),
        ),
      );
    // return Center(
    //   child: CustomScrollView(
    //     controller: _scrollController,
    //     slivers: <Widget>[
    //       // 公司名称栏
    //       SliverToBoxAdapter(
    //         child: Container(
    //           // padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
    //           margin: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
    //           alignment: Alignment.topCenter,
    //           color: Colors.yellow,
    //           height: 200,
    //           width: double.infinity,
    //           child: Column(
    //             children: <Widget>[
    //               Image.asset(
    //                 'assets/images/top.jpg',
    //                 scale: 0.618,
    //                 repeat: ImageRepeat.repeat,
                    
    //               ),
    //               Expanded(
    //                 child: Container(
    //                   color: Colors.blue,
    //                   constraints: BoxConstraints(
    //                     minHeight: 50,
    //                     maxHeight: 50
    //                   ),
    //                 ),
    //               )
    //             ],
    //           )
    //         )
    //       ),
    //       // 滚动信息栏
    //       // 提交率
    //       // 左边：排行，右边：文件栏
    //     ],
    //   ),
    // );
  }
  _launchURL() async{
    const url="http://129.0.99.51:8080/index";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '无法访问$url';
    }
  }
}