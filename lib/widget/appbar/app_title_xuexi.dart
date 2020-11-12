import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/routes.dart';
import 'package:fznews/widget/textfield/search_box.dart';

class XueXiTitle extends StatelessWidget{
  final avatar;
  final username;
  XueXiTitle({Key key,this.avatar,this.username}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SearchBox(
          backgroudColor: Colors.red[300],
          readOnly: true,
        ),
        ),
        SizedBox(
          width: 100,
        ),
        Container(
          child: avatar!=null?Container(
            child: PopupMenuButton<dynamic>(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(avatar)
                  ),
                ),
              ),
              onSelected: (dynamic value){
                App.router.navigateTo(context,value);
              },
              itemBuilder: (BuildContext context){
                List<PopupMenuEntry<dynamic>> list=[
                  PopupMenuItem(
                    value: Routes.AlterPassword,
                    child: Text('修改密码'),
                  ),
                  PopupMenuItem(
                    value: Routes.Login,
                    child: Text('退出登陆'),
                  ),
                ];
                return list;
              },
            ),
          ):GestureDetector(
            child: CircleAvatar(child:Text('游客'),radius: 25,),
            onTap: ()=>App.router.navigateTo(context,Routes.Login),
          ),
        ),
      ],
    );
  }

}