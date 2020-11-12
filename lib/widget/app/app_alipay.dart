import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/home_page.dart';
import 'package:fznews/layout/drawer.dart';
import 'package:fznews/routes.dart';
import 'package:fznews/widget/app/app_basic.dart';


// AppAlipay 支付宝首页样式,兼容web
class AppAlipay extends StatefulWidget{
  final Widget title;
  final List<RouteHandler> tabs;
  final List<RouteHandler> actions;
  final List<RouteHandler> bottoms;
  final TabController tabController;
  final List<Widget> titleWidgets;
  final Widget leading;
  final Widget drawer;
  final params;
  AppAlipay({Key key,this.title,this.tabs,
    this.tabController,this.titleWidgets,
    this.leading,this.actions,
    this.bottoms,this.drawer,this.params
    }):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _AppAlipayState();
  }


}

class _AppAlipayState extends State<AppAlipay> with TickerProviderStateMixin{

  List<Widget> _titleWidgets;
  Widget _drawer;
  Widget _leading;
  List<RouteHandler> _actions;
  List<RouteHandler> _tabs;
  // List<RouteHandler> _bottoms;
  TabController _tabController;
  double searchBoxWidth;
  @override
  void dispose(){
    super.dispose();
    _tabController.dispose();
  }

  @override
  void initState(){
    print('init app_aplipay');
    super.initState();
    // 抽屉
    _drawer=widget.drawer;
    if (_drawer==null&&Routes.getNeedsDrawerRegistry().length>0){
      _drawer=AppDrawer();
    }
    // 标题
    _titleWidgets = widget.titleWidgets;
    if (_titleWidgets==null){
        _titleWidgets=List();
          _titleWidgets.add(
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                App.router.navigateTo(context,Routes.Search);
              },
            )
          );
    }
    // 右边控件
    _actions=widget.actions;
    // if (_actions==null){
    //   _actions = <RouteHandler>[
    //       RouteHandler(title: 'Home', icon: Icons.directions_car,handler: (){return HomePage();}),
    //       RouteHandler(title: 'Bicycle', icon: Icons.directions_bike,handler: (){return ChoiceCard(title: 'Bicycle', icon: Icons.directions_bike);}),
    //       RouteHandler(title: 'Boat', icon: Icons.directions_boat,handler: (){return ChoiceCard(title: 'Boat', icon: Icons.directions_boat);}),
    //       RouteHandler(title: 'Bus', icon: Icons.directions_bus,handler: (){return ChoiceCard(title: 'Bus', icon: Icons.directions_bus);}),
    //       RouteHandler(title: 'Train', icon: Icons.directions_railway,handler: (){return ChoiceCard(title: 'Train', icon: Icons.directions_railway);}),
    //       RouteHandler(title: 'Walk', icon: Icons.directions_walk,handler: (){return ChoiceCard(title: 'Walk', icon: Icons.directions_walk);}),
    //   ];
    // }
    _tabs=widget.tabs;
    // if (_tabs==null) {
    //  _tabs= <RouteHandler>[
    //       RouteHandler(title: '扫一扫', icon: Icons.scanner,handler: ({Map<String,dynamic> params}){return ChoiceCard(title: 'Car', icon: Icons.directions_car);}),
    //       RouteHandler(title: '付钱', icon: Icons.payment,handler: ({Map<String,dynamic> params}){return ChoiceCard(title: 'Bicycle', icon: Icons.directions_bike);}),
    //       RouteHandler(title: '收钱', icon: Icons.money_off,handler: ({Map<String,dynamic> params}){return ChoiceCard(title: 'Boat', icon: Icons.directions_boat);}),
    //       RouteHandler(title: '卡包', icon: Icons.card_giftcard,handler: ({Map<String,dynamic> params}){return ChoiceCard(title: 'Bus', icon: Icons.directions_bus);}),
    //   ];
    // }
    _tabController=widget.tabController;
    if (_tabs!=null&&_tabController==null) {
      _tabController=TabController(length: _tabs.length,vsync: this);
    }
    // _bottoms=widget.bottoms;
    // if (_bottoms==null){
    //   _bottoms= <RouteHandler>[
    //       RouteHandler(title: '首页', icon: Icons.home,handler: (){return ChoiceCard(title: '首页', icon: Icons.home);}),
    //       RouteHandler(title: '理财', icon: Icons.payment,handler: (){return ChoiceCard(title: '理财', icon: Icons.payment);}),
    //       RouteHandler(title: '口碑', icon: Icons.money_off,handler: (){return ChoiceCard(title: '口碑', icon: Icons.money_off);}),
    //       RouteHandler(title: '朋友', icon: Icons.people,handler: (){return ChoiceCard(title: '朋友', icon: Icons.people);}),
    //       RouteHandler(title: '我的', icon: Icons.perm_contact_calendar,handler: (){return ChoiceCard(title: '我的', icon: Icons.perm_contact_calendar);}),
    //   ];
    // }
  }
  @override
  Widget build(BuildContext context) {
   return BasicApp(titleWidgets:_titleWidgets,title: widget.title,
    tabs: _tabs,tabController: _tabController,
    actions: _actions,
    leading:_leading,
    drawer: _drawer,
    body: HomePage(),
    );
  }
  
}


