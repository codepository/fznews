import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/widget/rating_bar_box.dart';

class EditorFlowCard extends StatelessWidget{
  final String route;
  final String avatar;
  final String title;
  final String subtitle;
  // 值范围是1~10
  final  star;
  EditorFlowCard({Key key,this.route,this.avatar,this.title,this.subtitle,this.star}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListTile(
        isThreeLine: true,
        onTap: (){
          App.router.navigateTo(context,route);
        },
        leading: ExcludeSemantics(
          child: CircleAvatar(
            child: avatar==null?Text('未知'):
            Image.network(
              avatar,
            ),
            radius: 30,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: RatingBarBox(stars: star,titles:App.config["title"],width: 120,fontSize: 18,)
      ),
    );
  }
  
} 