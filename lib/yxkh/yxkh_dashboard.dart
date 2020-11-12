import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/utils/screenUtil.dart';
import 'package:fznews/widget/card_tile.dart';
import 'package:fznews/yxkh/sidebar_menu.dart';
import 'package:fznews/yxkh/theme.dart';
// YxkhDashboardWidget 一线考核操作页面
class YxkhDashboardWidget extends StatefulWidget{
  final params;
  YxkhDashboardWidget({Key key,this.params}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _YxkhDashboardWidgetState();
  }

}
class _YxkhDashboardWidgetState extends State<YxkhDashboardWidget> with AutomaticKeepAliveClientMixin{
  var _params;
  List<Widget> pages=List();
  bool _showSidebar=true;
  int _selectIndex = 0;
  bool isInit=true;
  @override void initState(){
    super.initState();
    print("token:$_params");
    if (App.getToken()==null){
      if (_params!=null&&_params["token"]!=null){
        print("token:${_params["token"][0]}");
        App.setToken(_params["token"][0]);
      }
    }
    print("_params=$_params");
    pages.add(CardTile(
      iconBgColor: Colors.orange,
      cardTitle: 'Booking',
      icon: Icons.flight_takeoff,
      subText: 'Todays',
      mainText: '230',
    ));
    pages.add(CardTile(
      iconBgColor: Colors.blue,
      cardTitle: 'Booking',
      icon: Icons.flight_takeoff,
      subText: 'Todays',
      mainText: '230',
    ));
    pages.add(CardTile(
      iconBgColor: Colors.red,
      cardTitle: 'Booking',
      icon: Icons.flight_takeoff,
      subText: 'Todays',
      mainText: '230',
    ));
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("创建 yxkh_dashboard showSidebar:$_showSidebar");
    if (ScreenUtils.isSmallScreen(context)&&isInit){
      _showSidebar=false;
      isInit=false;
    }
    final _media = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (BuildContext context,BoxConstraints constraints){
        return Material(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SideBarMenu(
                collapsed: _showSidebar,
                onTap: (index){
                  _selectIndex=index;
                  setState(() {
            
                  });
                },
                show: (bool show){
                  _showSidebar=show;
                  setState(() {
                    
                  });
                },
              ),
              Flexible(
                fit:FlexFit.loose,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: appBarHeight,
                      width: _media.width,
                      child: AppBar(
                        leading: !_showSidebar?IconButton(color: Colors.white,icon: Icon(Icons.reorder),onPressed: (){
                          _showSidebar=true;
                          setState(() {
                            
                          });
                        },):Container(),
                        elevation: 4,
                        centerTitle: true,
                        title: Text(
                          '一线考核',
                        ),
                        backgroundColor: drawerBgColor,
                      ),
                    ),
                    Expanded(
                        child: Stack(
                          children: pages.asMap().keys.map((index)=>Offstage(
                            offstage: _selectIndex!=index,
                            child: TickerMode(enabled: _selectIndex==index,child: pages[index],),
                          )).toList(),
                        ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
  
}