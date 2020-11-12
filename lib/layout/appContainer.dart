import 'package:flutter/material.dart';
import 'package:fznews/routes.dart';
// APP 容器
class AppContainer extends StatefulWidget{
  final params;
  AppContainer({Key key,this.params}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    
    return _AppContainerState();
  }
  
}

class _AppContainerState extends State<AppContainer>  with AutomaticKeepAliveClientMixin {
  final defaultItemColor = Color.fromARGB(255, 125, 125, 125);
  List<BottomNavigationBarItem> _bottomWidgets;
  List<Widget> pages=List();
  List<RouteHandler> _bottoms;
  int _selectIndex = 0;
  // final items = App.config["bottomBar"]["items"];
  @override
  bool get wantKeepAlive => true;
  
  @override
  void initState(){
    super.initState();
     print("初始化 appContainer");
    _bottomWidgets=List();
    _bottoms=Routes.getNeedsBottomNavRegistry();
    _bottoms.forEach((item){
      _bottomWidgets.add(
        BottomNavigationBarItem(
          icon: Icon(item.icon),
          title: Text(
            item.title,
            style: TextStyle(fontSize: 10.0),
          ),
          activeIcon: Icon(
            item.icon,
            color: Colors.blue,
          ),
        )
      );
      var handler=item.handler;
      if (handler!=null){
        pages.add(
          handler()
        );
      }

    });
        // print(FluroRouter.routerMap[item['text']]);

  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // print('build app container');
    return Scaffold(
      body: Stack(
        children: pages.asMap().keys.map((index)=>
          Offstage(
            offstage: _selectIndex != index,
            child: TickerMode(enabled: _selectIndex == index, child: pages[index]),
          )
        ).toList(),
      ),
      backgroundColor: Color.fromARGB(255, 248, 248, 248),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomWidgets,
        onTap: (int index) {
          setState((){
            ///这里根据点击的index来显示，非index的page均隐藏
            _selectIndex = index;
          });
        },
        //图标大小
        iconSize: 48,
        //当前选中的索引
        currentIndex: _selectIndex,
        //选中后，底部BottomNavigationBar内容的颜色(选中时，默认为主题色)（仅当type: BottomNavigationBarType.fixed,时生效）
        fixedColor: Color.fromARGB(255, 0, 188, 96),
        type: BottomNavigationBarType.fixed,
      )
    );
  }
}