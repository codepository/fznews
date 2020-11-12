import 'package:flutter/material.dart';
import 'package:fznews/routes.dart';



import '../app.dart';
// import '../router.dart';

class AppDrawer extends StatelessWidget {
  final List<RouteHandler> drawerItems = Routes.getNeedsDrawerRegistry();
  final String avatar='https://upload.jianshu.io/users/upload_avatars/7700793/dbcf94ba-9e63-4fcf-aa77-361644dd5a87?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240';
  List<Widget> getItems(BuildContext context){
         // 提取图片主要颜色
    // var paletteGenerator = await PaletteGenerator.fromImageProvider(NetworkImage(avatar));
    // if (paletteGenerator != null && paletteGenerator.colors.isNotEmpty) {
    //   weeklyHotColor = (paletteGenerator.colors.toList()[0]);
    // }   
    List<Widget> items = List();
    items.add(
      UserAccountsDrawerHeader(
        accountName: Text('游客'),
        accountEmail: Text('邮箱'),
        currentAccountPicture: GestureDetector(
          onTap: ()=> print('current user'),
          child: CircleAvatar(
            backgroundImage: NetworkImage(avatar),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.blue
        ),
      )
    );
    if (drawerItems!=null){
      drawerItems.forEach((item){
        items.add(
          ListTile(
            trailing: Icon(item.icon),
            title: Text(item.title),
            onTap: (){
              Navigator.pop(context);
              App.router.navigateTo(context, item.route);
            },
          )
        );
      });
    }
    return items;
  }
  @override
  Widget build(BuildContext context) { 
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: getItems(context),
      ),
    );
  }
  
}