import 'package:flutter/material.dart';
import 'package:fznews/routes.dart';
// 仿学习强国导航栏
class XueXiAppBar extends StatefulWidget{
  final Widget title;
  final double titleHeight;
  final double flexibleSpaceBarHeight;
  final List<RouteHandler> tabs;
  final TabController tabController;
  final Widget leading;
  final Color backgroundColor;
  final callback;
  XueXiAppBar({Key key,
    this.title,this.flexibleSpaceBarHeight,this.callback,
    this.tabs,this.tabController,this.leading,this.backgroundColor,this.titleHeight
    }):assert(title!=null,tabs!=null),super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _XueXiAppBarState();
  }

}
class _XueXiAppBarState extends State<XueXiAppBar> with SingleTickerProviderStateMixin{
  Widget _title;
  double _titleHeight;
  double _flexibleSpaceBarHeight;
  TabController _tabController;
  List<RouteHandler> _tabs;
  Widget _leading;
  var _backgroundColor;
  @override
  void dispose(){
    super.dispose();
    if(_tabController!=null)_tabController.dispose();
    // _scrollController.dispose();
  }
  @override
  void initState(){
    super.initState();
    _tabs=widget.tabs;
    _title=widget.title;
    _titleHeight=widget.titleHeight==null?80:widget.titleHeight;
    _leading=widget.leading;
    _tabController=widget.tabController;
    if (_tabController==null) _tabController=TabController(vsync: this,length:_tabs.length);
    _flexibleSpaceBarHeight=getFlexibleSpaceBarHeight();
    _backgroundColor=widget.backgroundColor!=null?widget.backgroundColor:Colors.blue;
    
  }
  double getFlexibleSpaceBarHeight(){
    _flexibleSpaceBarHeight=widget.flexibleSpaceBarHeight;
    if (_flexibleSpaceBarHeight!=null) return _flexibleSpaceBarHeight; 
    if (_tabs==null) {
      return 80.0;
    }
    return 120.0;
  }
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      titleSpacing: 0,
      title: Container(
          width: double.infinity,
          height: _titleHeight,
          color: _backgroundColor,
          child: _title
      ),
      //展开高度
      expandedHeight: _flexibleSpaceBarHeight,
      //是否随着滑动隐藏标题
      floating: false,
      //是否固定在顶部
      pinned: true,
      //可折叠的应用栏
      leading: Container(
        color: _backgroundColor,
        child: _leading,
      ),
      backgroundColor: _backgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        background: AppBar(
          textTheme: TextTheme(headline1:TextStyle(color: Colors.black,fontSize: 15) ),
          backgroundColor: Colors.white,
          bottomOpacity: 0.8,
          bottom: _tabs!=null?TabBar(
            isScrollable: false,
            controller: _tabController,
            unselectedLabelStyle: TextStyle(color: Colors.black,fontSize: 15),
            // 字体颜色
            labelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.grey,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(color: Colors.black,fontSize: 15),
            tabs: _tabs.map((RouteHandler choice) {
              return Tab(
                text: choice.title,
              );
            }).toList(),
            onTap: (index){
              if (widget.callback!=null){
                widget.callback(index);
              }
            },
            
        ):null
        ),
      ),
    );
  }
  
}