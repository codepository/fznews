import 'package:flutter/material.dart';
import 'package:fznews/app.dart';

class UserCard extends StatelessWidget{
  final String route;
  final String avatar;
  final String title;
  final String subtitle;
  UserCard({Key key,this.route,this.title,this.avatar,this.subtitle}):super(key:key);

  @override
  Widget build(Object context) {
    return Container(
      child: ListTile(
        isThreeLine: true,
        onTap: (){
          App.router.navigateTo(context,route);
        },
        leading: ExcludeSemantics(
          child: CircleAvatar(
            child:Icon(Icons.perm_contact_calendar),
            // child: avatar==null?Text('未知'):
            // Image.network(
            //   avatar,
            // ),
            radius: 30,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}