import 'package:flutter/material.dart';
import 'package:fznews/routes.dart';
import 'package:fznews/widget/align_boom_menu.dart';

// APP 容器
class AppContainer extends StatefulWidget {
  final params;
  AppContainer({Key key, this.params}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AppContainerState();
  }
}

class _AppContainerState extends State<AppContainer> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final defaultItemColor = Color.fromARGB(255, 125, 125, 125);
  // List<BottomNavigationBarItem> _bottomWidgets;
  List<BoomMenuItem> boomMenu;
  List<Widget> pages = List();
  List<RouteHandler> _bottoms;
  int _selectIndex = 0;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    boomMenu = List();
    _bottoms = Routes.getNeedsBottomNavRegistry();
    for (var i = 0; i < _bottoms.length; i++) {
      boomMenu.add(BoomMenuItem(
        child: Icon(_bottoms[i].icon),
        title: _bottoms[i].title,
        subtitle: _bottoms[i].subTitle,
        titleColor: _bottoms[i].titleColor,
        subTitleColor: _bottoms[i].subTitleColor,
        backgroundColor: _bottoms[i].backgroundColor,
        onTap: () {
          setState(() {
            ///这里根据点击的index来显示，非index的page均隐藏
            _selectIndex = i;
          });
        },
      ));
      var handler = _bottoms[i].handler;
      if (handler != null) {
        pages.add(handler());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: pages
            .asMap()
            .keys
            .map((index) => Offstage(
                  offstage: _selectIndex != index,
                  child: TickerMode(enabled: _selectIndex == index, child: pages[index]),
                ))
            .toList(),
      ),
      backgroundColor: Color.fromARGB(255, 248, 248, 248),
      floatingActionButton: AlignBoomMenu(
        alignment: Alignment.bottomCenter,
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.green,
        animatedIconTheme: IconThemeData(size: 50.0),
        // onOpen: () => print("open"),
        // onClose: () => print("close"),
        scrollVisible: true,
        overlayColor: Colors.black,
        overlayOpacity: 0.7,
        children: boomMenu,
      ),
    );
  }
}
