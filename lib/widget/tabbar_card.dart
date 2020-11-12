import 'package:flutter/material.dart';


class TabBarCard extends StatefulWidget{
  final state = _TabBarCardState();
  final List<TabItem> tabs;
  final unselectedLabelColor;
  final backGroudColor;
  final callback;
  TabBarCard({Key key,this.tabs,this.unselectedLabelColor,this.backGroudColor,this.callback}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return state;
  }
  
}
class _TabBarCardState extends State<TabBarCard> with SingleTickerProviderStateMixin{
  TabController _tabController;
  Widget tabBar;
  int selectIndex;
  @override
  void dispose(){
    _tabController.removeListener(listener);
    _tabController.dispose();
    super.dispose();
  }
  @override
  void initState(){
    super.initState();
    _tabController = TabController(vsync: this,length: widget.tabs.length);
    _tabController.addListener(listener);
    tabBar = TabBar(
      controller: _tabController,
      indicatorColor: Color.fromARGB(255, 45, 45, 45),
      labelColor: Color.fromARGB(255, 45, 45, 45),
      labelStyle: TextStyle(
        fontSize: 20,
        color: Color.fromARGB(255, 45, 45, 45),
        fontWeight: FontWeight.bold
      ),
      unselectedLabelColor: widget.unselectedLabelColor!=null?widget.unselectedLabelColor:Color.fromARGB(255, 135, 135, 135),
      unselectedLabelStyle: TextStyle(
        fontSize: 20, color: Color.fromARGB(255, 135, 135, 135)
      ),
      indicatorSize: TabBarIndicatorSize.label,
      isScrollable: true,
      tabs: widget.tabs.map(
        (tab){
          return Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(tab.title),
          );
        }
      ).toList(),
      onTap: (index){
        if (widget.callback!=null) {
          widget.callback(index);
        }
      },
    );
  }
  void listener(){
    if (_tabController.indexIsChanging){
      // print("tabbarcard index changing=$index");
      // selectIndex = index;
      // setState(() {
      //   if (index == 0) {

      //   }
      // });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backGroudColor!=null?widget.backGroudColor:Colors.blue,
      child: Row(
        children: <Widget>[
          Expanded(
            child: tabBar,
            flex: 1,
          )
        ],
      ),
    );
  }
  
}
class TabItem{
  final String title;
  TabItem(this.title);
}