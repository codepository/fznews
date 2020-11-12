import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/search.dart';
import 'package:fznews/tongji/editor_detail.dart';
import 'package:fznews/tongji/tongji.dart';
import 'package:fznews/user/AlterPasswordWidget.dart';
import 'package:fznews/user/label_add_widget.dart';
import 'package:fznews/user/login.dart';
import 'package:fznews/user/role_user_widget.dart';
import 'package:fznews/user/userinfo_widget.dart';
import 'package:fznews/user/users_widget.dart';
import 'package:fznews/widget/app/app_xuexi.dart';
import 'package:fznews/widget/app/choice_card.dart';
import 'package:fznews/widget/appbar/app_title_xuexi.dart';
import 'package:fznews/widget/login/forgetPassword.dart';
import 'package:fznews/yxkh/quantitative.dart';
import 'package:fznews/yxkh/yxkh_dashboard.dart';
import 'package:fznews/yxkh/yxkh_home.dart';

import 'layout/appContainer.dart';
class Routes {
  static const String QuantitativeScroing = '/yxkh/quantitative';
  // YxkhDashboard 一线考核操作页面
  static const String YxkhDashboard='/yxkhDashboard';
  static const String Tongji = '/tongji/tongji';
  static const String Editor = '/tongji/editor';
  static const String Editor_Detail = '/tongji/editor/detail';
  static const String Search='/search';
  static const String Home='/home';
  static const String Dashboard='/dashboard';
  static const String Users='/users';
  static const String ForgetPassword='/users/forgetpassword';
  static const String AlterPassword='/users/alterpassword';
  static const String Login='/login';
  static const String Userinfo='/users/userinfo';
  static const String LabelWithUser='/label/label';
  static const String AddLabels='/label/add';
  static const String YxkhHomePath ='/yxkh/home';
  static List<RouteHandler> routers;

  // 获取路由，可用于main.dart中的路由注册，这样就可以直接通过url访问
  static Map<String,Widget Function(BuildContext)> getNeedsRoutesRegistry(BuildContext context){
    
    return routers.takeWhile(needsRoutesRegistry).toList().asMap().map((k,v)=>MapEntry<String,Widget Function(BuildContext)>(v.route,(context)=>v.handler()));

  }
  static List<RouteHandler> getRouters(){
    return routers;
  }
    // 需要显示在底部菜单栏的项
  static  List<RouteHandler> getNeedsBottomNavRegistry(){
    // print('底部菜单栏');
    var result=routers.takeWhile(needsBottomNavRegistry).toList();
    return result.length==0?[]:result;
  }
  // 需要显示在侧边栏
  static List<RouteHandler> getNeedsDrawerRegistry(){
    // print('侧边栏');
    var result=routers.takeWhile(needsDrawerRegistry).toList();
    return result.length==0?[]:result;
  }
  // 可以搜索的功能
  static List<RouteHandler> getSearchRegistry(){
    var result=routers.takeWhile(needsRoutesRegistry).toList();
    return result.length==0?[]:result;
  }
  static bool needsRoutesRegistry(RouteHandler r){
    if (r.meta==null) return false;
    return r.meta.needsRoutesRegistry;
  }
  static bool needsBottomNavRegistry(RouteHandler r){
    if (r.meta==null) return false;
    return r.meta.needsBottomRegistry;
  }
   static bool needsDrawerRegistry(RouteHandler r){
    if (r.meta==null) return false;
    return r.meta.needsDrawerRegistry;
  }

  static List<RouteHandler> homePageTabs=<RouteHandler>[
    RouteHandler(title: '流量', icon: Icons.scanner,handler: ({Map<String,dynamic> params}){return ChoiceCard(title: 'Car', icon: Icons.directions_car);}),
    RouteHandler(title: '用户', icon: Icons.payment,handler: ({Map<String,dynamic> params}){return ChoiceCard(title: 'Bicycle', icon: Icons.directions_bike);}),
  ];
  // 获取路由
  static RouteHandler getRoute(String path){
    if (path==null) return null;
    var route=path.split("?")[0];
    print("跳转至 $route");
    return routers.singleWhere((r)=>r.route==route);
  }
  // 检查权限
  static bool checkAuthority(RouteHandler routeHandler){
    // 勿须验证
    if (routeHandler.meta==null||routeHandler.meta.authority==null) {
      // print("无需验证");
      return true;
    }
    // 用户无权限
    var labels=App.userinfos.labels;
    if (labels==null||labels.length==0) {
      // print('用户标签为空');
      return false;
    }
    // 用户权限不匹配
    return routeHandler.meta.authority.indexWhere((a){
      return labels.indexWhere((l)=>l.labelname==a)>-1;
    })>-1;    
  }
  static void setRouters(){
    print('初始化：设置路由');
    routers=<RouteHandler>[
    RouteHandler(title: "首页",icon: Icons.home,handler:({Map<String,dynamic> params})=>XueXiApp(
        params:params,
        title: XueXiTitle(username: App.userinfos.user?.name,avatar: App.userinfos.user?.avatar,),
        tabs: homePageTabs,
        leading: Icon(Icons.home),
        
      ),route: Routes.Home,
        meta: RouteMeta(
          needsBottomRegistry: true,needsDrawerRegistry: false,needsRoutesRegistry: true
        ),
       ),
      
    RouteHandler(title: "流量",icon: Icons.settings_input_component,handler:({Map<String,dynamic> params})=>TongjiWidget(params:params),route: Routes.Tongji,
       meta: RouteMeta(
        needsRoutesRegistry: true,needsBottomRegistry: true,needsDrawerRegistry: false,
      ),
    ),
    RouteHandler(title: "一线考核",icon: Icons.edit,handler:({Map<String,dynamic> params})=>YxkhHome(params:params),route: Routes.YxkhHomePath,
       meta: RouteMeta(
        needsRoutesRegistry: true,needsBottomRegistry: true,needsDrawerRegistry: false,
      ),
    ),
    RouteHandler(title: "一线考核系统",icon:Icons.text_fields,handler: ({Map<String,dynamic> params})=>YxkhDashboardWidget(),route: Routes.YxkhDashboard,
      meta: RouteMeta(needsRoutesRegistry: true,needsBottomRegistry: true),
    ),
    RouteHandler(title: "用户",icon: Icons.people,handler:({Map<String,dynamic> params})=>UsersWidget(params:params),route: Routes.Users,
      meta: RouteMeta(
         needsRoutesRegistry: true,needsBottomRegistry:true
      ),
    ),
    // app页面
    RouteHandler(title: "app",icon: Icons.home,handler:({Map<String,dynamic> params})=>AppContainer(params: params,),route: Routes.Dashboard,
      meta: RouteMeta(
        needsRoutesRegistry: true,
      ),
      ),
    // 登陆页面
    RouteHandler(handler:({Map<String,dynamic> params})=>LoginWidget(),route: Routes.Login),
    // 忘记密码
    RouteHandler(handler:({Map<String,dynamic> params})=>ForgetPasswordWidget(),route: Routes.ForgetPassword),
    // 修改密码
    RouteHandler(handler: ({Map<String,dynamic> params})=>AlterPasswordWidget(),route:Routes.AlterPassword,
      meta: RouteMeta(needsDrawerRegistry: true),
    ),
    RouteHandler(handler:({Map<String,dynamic> params})=>UserinfoWidget(params:params),route: Routes.Userinfo,
      
    ),
    RouteHandler(handler:({Map<String,dynamic> params})=>QuantitativeScoringPage(params:params),route: Routes.QuantitativeScroing ),
    RouteHandler(handler:({Map<String,dynamic> params})=>EditorDetail(params:params),route: Routes.Editor_Detail ),
    RouteHandler(handler:({Map<String,dynamic> params})=>SearchPage(params:params),route: Routes.Search ),
    RouteHandler(handler:({Map<String,dynamic> params})=>LabelWithUserWidget(params:params),route: Routes.LabelWithUser ),
    // AddLabels 添加标签
    RouteHandler(handler: ({Map<String,dynamic> params})=>AddLabelsWidget(),route:Routes.AddLabels,
      meta: RouteMeta(authority: ['系统管理员']),
    ),
  ];
  }
}

class RouteHandler {

 Function({Map<String,dynamic> params}) handler;
 String route;
 IconData icon; 
 String title;
 RouteMeta meta;
 RouteHandler({this.handler,this.icon,this.title,this.route,this.meta});
}
class RouteMeta{
  // 是否在drawer中显示
  bool needsDrawerRegistry;
  // 是否在底部菜单栏显示
  bool needsBottomRegistry;
  // 是否需要路由注册，这样就可以直接通过url访问
  bool needsRoutesRegistry;
  // 需要访问权限
  List<String> authority;
  RouteMeta({this.needsDrawerRegistry=false,this.needsBottomRegistry=false,this.needsRoutesRegistry=false,this.authority});
}
