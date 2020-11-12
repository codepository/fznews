import 'package:flutter/material.dart';
import 'package:fznews/routes.dart';

// This app is a stateful, it tracks the user's current choice.
class BasicApp extends StatefulWidget {
  final Widget title;
  final List<Widget> titleWidgets;
  final List<RouteHandler> tabs;
  final List<RouteHandler> actions;
  // final List<RouteHandler> bottoms;
  final TabController tabController;
  final Widget leading;
  final Widget body;
  // 默认为false,为true时body不缓存
  final bool refreshBody;
  final Widget drawer;
  final double flexibleSpaceBarHeight;
  BasicApp({Key key,this.title,this.tabs,
    this.tabController,this.titleWidgets,
    this.actions,this.leading,
    this.body,this.flexibleSpaceBarHeight,
    this.drawer,this.refreshBody=false
    // this.bottoms,
    }):super(key:key);
  @override
  _BasicAppState createState() => new _BasicAppState();
}

class _BasicAppState extends State<BasicApp> with TickerProviderStateMixin{
  RouteHandler _selectedChoice; // The app's "state".
  TabController _tabController;
  List<RouteHandler> _actions;
  List<Widget> _actionWidgets;
  List<RouteHandler> _tabs;
  // List<RouteHandler> _bottoms;
  // List<BottomNavigationBarItem> _bottomWidgets;
   List<Widget> pages;
  // int _bottomSelect=0;
  Widget _leading;
  Widget _body;
  Widget _drawer;
  double _flexibleSpaceBarHeight;
  void _select(RouteHandler choice){
    if (_selectedChoice==choice){
      return;
    }
    _selectedChoice = choice;
    _body=choice.handler();
    setState(() {
    });
  }
  @override
  void dispose(){
    super.dispose();
    if(_tabController!=null)_tabController.dispose();
    // _scrollController.dispose();
  }
  @override
  void initState(){
    super.initState();
    // print('init app_basic');
    _tabs=widget.tabs;
     _tabController=widget.tabController;
    // 当choice小于4时，直接显示三个btn,大于四时显示popmenu
    setActions();
    // leading
    _leading = widget.leading;
    // _scrollController=ScrollController();
    // setBottoms();
    _flexibleSpaceBarHeight=getFlexibleSpaceBarHeight();
    _drawer=widget.drawer;
    // 要放在最后
    _body=getBody();
  }
  double getFlexibleSpaceBarHeight(){
    _flexibleSpaceBarHeight=widget.flexibleSpaceBarHeight;
    if (_flexibleSpaceBarHeight!=null) return _flexibleSpaceBarHeight; 
    if (_tabs==null) {
      return 80.0;
    }
    return 120.0;
  }
  Widget getBody(){
    if (widget.body!=null){
      return widget.body;
    }
    // if (_bottoms!=null){
    //   return Stack(
    //     children: pages.asMap().keys.map((index)=>
    //       Offstage(
    //         offstage: _bottomSelect != index,
    //         child: TickerMode(enabled: _bottomSelect == index, child: pages[index]),
    //       )
    //     ).toList(),
    //   );
    // }
    if(_tabs!=null) {
      _selectedChoice = _tabs[0];
      return _tabs[0].handler();
    }
    if (_actions!=null){
      _selectedChoice = _actions[0];
      return _actions[0].handler();
    }
    return Container(
      child: Text('home'),
    );
  }
  void setActions(){
    _actions=widget.actions;
    if (_actions==null){
      return;
    }
    // if (_actions==null){
    //   _actions=<RouteHandler>[
    //       RouteHandler(title: 'Car', icon: Icons.directions_car,handler: (){return ChoiceCard(title: 'Car', icon: Icons.directions_car);}),
    //       RouteHandler(title: 'Bicycle', icon: Icons.directions_bike,handler: (){return ChoiceCard(title: 'Bicycle', icon: Icons.directions_bike);}),
    //       RouteHandler(title: 'Boat', icon: Icons.directions_boat,handler: (){return ChoiceCard(title: 'Boat', icon: Icons.directions_boat);}),
    //       RouteHandler(title: 'Bus', icon: Icons.directions_bus,handler: (){return ChoiceCard(title: 'Bus', icon: Icons.directions_bus);}),
    //       RouteHandler(title: 'Train', icon: Icons.directions_railway,handler: (){return ChoiceCard(title: 'Train', icon: Icons.directions_railway);}),
    //       RouteHandler(title: 'Walk', icon: Icons.directions_walk,handler: (){return ChoiceCard(title: 'Walk', icon: Icons.directions_walk);}),
    //   ];
    // }
    _actionWidgets=List();
    if (_actions.length<4){
      _actionWidgets=_actions.map((c)=>IconButton(
        icon: Icon(c.icon),
        onPressed: (){_select(c);},
      )).toList();
    }else{
      _actionWidgets.add(IconButton( // action button
        icon: Icon(_actions[0].icon),
        onPressed: () { _select(_actions[0]); },
      ));
      _actionWidgets.add(IconButton( // action button
        icon: Icon(_actions[1].icon),
        onPressed: () { _select(_actions[1]); },
      ));
      _actionWidgets.add(PopupMenuButton<RouteHandler>( // overflow menu
        onSelected: _select,
        itemBuilder: (BuildContext context) {
          return _actions.skip(2).map((RouteHandler choice) {
            return PopupMenuItem<RouteHandler>(
              value: choice,
              child: Text(choice.title),
            );
          }).toList();
        },
      ));
    }

            
  }
  @override
  Widget build(BuildContext context) {
    // print('app_basic build');
    return MaterialApp(
      home: Scaffold(
        drawer: _drawer,
        body: NestedScrollView(
          body: widget.refreshBody?getBody():_body,
          headerSliverBuilder: (BuildContext context,bool innerBoxIsScrolled){
            return <Widget>[
              SliverAppBar(
                 //展开高度
                  expandedHeight: _flexibleSpaceBarHeight,
                  //是否随着滑动隐藏标题
                  floating: false,
                  //是否固定在顶部
                  pinned: true,
                  //可折叠的应用栏
                  leading: _leading,
                  title: widget.title,
                  actions: _actionWidgets,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    // title: getTitle(context),
                    background: AppBar(
                      bottom: _tabs!=null?TabBar(
                          isScrollable: false,
                          controller: _tabController,
                          tabs: _tabs.map((RouteHandler choice) {
                            return Tab(
                              text: choice.title,
                              icon: Icon(
                                choice.icon,
                                size: 40,
                              ),
                            );
                          }).toList(),
                          onTap: (index){
                            _select(_tabs[index]);
                          },
                      ):null,
                    ),
                  ),
              ),
            ];
          },
        ),
      ),
    );
  }
}





