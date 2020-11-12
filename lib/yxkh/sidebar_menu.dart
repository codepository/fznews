import 'package:flutter/material.dart';
import 'package:fznews/yxkh/menu_item_tile.dart';
import 'package:fznews/yxkh/theme.dart';

import 'menu.dart';

class SideBarMenu extends StatefulWidget{
  final onTap;
  final show;
  final bool collapsed;
  SideBarMenu({Key key,this.onTap,this.show,this.collapsed}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _SideBarMenuState();
  }

}
class _SideBarMenuState extends State<SideBarMenu> with SingleTickerProviderStateMixin {
  var _onTap;
  var _show;
  double maxWidth = 250;
  double minWidgth = 70;
  bool collapsed = false;
  int selectedIndex = 0;
  bool isInit=true;
  AnimationController _animationController;
  Animation<double> _animation;

  @override void initState(){
    super.initState();
    _onTap=widget.onTap;
    _show=widget.show;
    _animationController = AnimationController(vsync: this,duration: Duration(microseconds: 50));
    _animation =Tween<double>(begin:maxWidth,end:minWidgth).animate(_animationController);
  }
  @override
  Widget build(BuildContext context) {
    // print("创建 sidebar_menu _animation.value:${_animation.value}");
    collapsed=widget.collapsed;
    _animationController.reverse();
    return  collapsed?AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(blurRadius: 10, color: Colors.black26, spreadRadius: 2)
            ],
            color: drawerBgColor,
          ),
          width: _animation.value,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200,
                decoration: BoxDecoration(
                    color: drawerBgColor,
                    // image: DecorationImage(
                    //   image: NetworkImage(
                    //       'https://backgrounddownload.com/wp-content/uploads/2018/09/google-material-design-background-6.jpg'),
                    //   fit: BoxFit.cover,
                    // )
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: _animation.value >= 250 ? 30 : 20,
                          ),
                          SizedBox(
                            width: _animation.value >= 250 ? 20 : 0,
                          ),
                          (_animation.value >= 250)
                              ? Text('Yasin ilhan',
                                  style: menuListTileDefaultText)
                              : Container(),
                        ],
                      ),
                      SizedBox(
                        height: _animation.value >= 250 ? 20 : 0,
                      ),
                      Spacer(),
                      (_animation.value >= 250)
                          ? Text(
                              'Yasin ilhan',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Container(),
                      (_animation.value >= 250)
                          ? Text(
                              'yasinilhan61@gmail.com',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, counter) {
                    return Divider(
                      height: 2,
                    );
                  },
                  itemCount: menuItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MenuItemTile(
                      title: menuItems[index].title,
                      icon: menuItems[index].icon,
                      animationController: _animationController,
                      isSelected: selectedIndex == index,
                      onTap: () {
                        selectedIndex = index;
                          if (_onTap!=null) _onTap(index);
                      },
                    );
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  collapsed = !collapsed;
                  _show(collapsed);
                  collapsed
                        ? _animationController.reverse()
                        : _animationController.forward();
                },
                child: AnimatedIcon(
                  icon: AnimatedIcons.close_menu,
                  progress: _animationController,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          )
        );
      },
    ):Container();
  }
}