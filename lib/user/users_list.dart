import 'package:flutter/material.dart';
import 'package:fznews/http/user_api.dart';
import 'package:fznews/routes.dart';
import 'package:fznews/tongji/editor_flow.dart';
import 'package:fznews/tongji/model/tongji_model.dart';
import 'package:fznews/user/user_card.dart';
import 'package:fznews/widget/textfield/normal.dart';

import '../app.dart';

class UsersList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _UsersListState();
  }

}
class _UsersListState extends State<UsersList> with SingleTickerProviderStateMixin{
  ScrollController _scrollController;
  List<dynamic> dataList;
  Tongji params = Tongji();
  int pageNumber;
  bool noMore;
  bool isLoading;
  @override
  void initState(){
    super.initState();
    noMore=false;
    isLoading=false;
    _scrollController=ScrollController();
      _scrollController.addListener(
      (){
        if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent-50){
          _getMoreData();
        }
      }
    );
    dataList=List();
    pageNumber=1;
    setParams();
    _getMoreData();
  }
  @override
  void dispose(){
    super.dispose();
    _scrollController.dispose();
  }
  void setParams(){
    params.body.method = "visit/user/getUsers";
    params.body.maxResults = 50;
    params.body.startIndex = 0;
    params.body.total = 0;
  }
  void resetData(){
     params.body.startIndex = 0;
     params.body.total = 0;
     pageNumber = 1;
     dataList.clear();
  }
  void _getMoreData() async{
    if(noMore) return;
    if (params.body.startIndex !=0 &&( params.body.total<=dataList.length || params.body.startIndex>=params.body.total)){
      noMore = true;
      return;
    }
    if (!isLoading){
      isLoading=true;
      this.params.body.startIndex = (this.pageNumber - 1) * this.params.body.maxResults;
      this.pageNumber++;
      UserAPI.getData(params.toJson()).then((data){
        if (data["status"]!=200) return;
        var result = Tongji.fromJson(data['message']);
        params.body.total = result.body.total;
        setState(() {
          isLoading=false;
          if (result.body.data!=null) dataList.addAll(result.body.data[0]);
        });
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                      child: Text(
                        '用户列表',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                  ),
                  FlatButton.icon(
                    icon: Icon(Icons.refresh),
                    label: Text("同步部门领导",style: TextStyle(fontSize: 10),),
                    color: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius:BorderRadius.all(Radius.circular(20)), 
                    ),
                    onPressed: (){
                      UserAPI.syncLeadership().then((data){
                        if (data["status"]!=200){
                          App.showAlertError(context,data["message"]);
                          return;
                        }
                        App.showAlertInfo(context,"同步成功");
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              maxHeight: 50,
              minHeight: 50,
              child: Container(
                height: 300,
                child: USearchBoxWidget(callback:(val){
                  if (val==null) return;
                  params.body.userName = val["username"];
                  resetData();
                  setState(() {
                  });
                  _getMoreData();
                }),
              ),
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context,int index){
                var user=dataList[index];
                String gender=user["gender"]==1?"男":"女";
                return Center(
                  child: UserCard(
                    title: '${user["name"]}/$gender',
                    subtitle: '${user["departmentname"]}',
                    avatar: user["avatar"],
                    route: '${Routes.Userinfo}?userid=${user["id"]}',
                  ),
                );
              },
              childCount: dataList.length
            ),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 600,
              crossAxisSpacing: 10,
              childAspectRatio: 600/100,
            ),
          ),
        ],
      )
    );
  }
}
class USearchBoxWidget extends StatefulWidget{
  final callback;
  USearchBoxWidget({Key key,this.callback}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _USearchBoxWidgetState();
  }

}
class _USearchBoxWidgetState extends State<USearchBoxWidget> with TickerProviderStateMixin{
  List<RouteHandler> _tabs;
  TextEditingController _userNameTextEditingController;
  var _callback;
  TabController _tabsController;
  @override void dispose(){
    super.dispose();
    _tabsController.dispose();
    _userNameTextEditingController.dispose();
  }
  @override void initState() {
    super.initState();
    
    _callback=widget.callback;
    _tabs=<RouteHandler>[
      RouteHandler(title: '自定义', icon: Icons.directions_bus, handler:({Map<String,dynamic> params}){
          showAlertDialog();
        }),
    ];
    _tabsController=TabController(length: _tabs.length,vsync: this);
  _userNameTextEditingController=TextEditingController();
  }
  void showAlertDialog(){
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
          return AlertDialog(
              title: Text('自定义查询'),
              content: Column(
                children: <Widget>[
                  TextFieldNormal(
                    textEditingController: _userNameTextEditingController,
                    labelText: "用户名",
                    helperText: "输入用户名",
                  ),
                ],
              ),
              actions: <Widget>[
                  FlatButton(
                      child: Text('确定'),
                      onPressed: () {
                          Navigator.of(context).pop();
                          _callback({"username":_userNameTextEditingController.text});
                      },
                  ),
              ],
          );
      },
    );
  } 
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        isScrollable: true,
        controller: _tabsController,
        indicatorColor: Color.fromARGB(255, 45, 45, 45),
          labelColor: Color.fromARGB(255, 45, 45, 45),
          labelStyle: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 45, 45, 45),
            fontWeight: FontWeight.bold
          ),
          unselectedLabelColor: Color.fromARGB(255, 135, 135, 135),
          unselectedLabelStyle: TextStyle(
            fontSize: 15, color: Color.fromARGB(255, 135, 135, 135)
          ),
          indicatorSize: TabBarIndicatorSize.label,
          onTap: (index){
            _tabs[index].handler();
          },
          tabs:_tabs.map((RouteHandler choice){
            return Tab(
              text: choice.title,
            );
          }).toList(),
      ),
    );
  }
  
}