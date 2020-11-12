import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/routes.dart';

class ServiceItem extends StatelessWidget {
  final RouteHandler data;
  ServiceItem({Key key,this.data}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 5),
      child: GestureDetector(
        onTap: (){
          App.router.navigateTo(context,data.route);
        },
        child: Column(
        children: <Widget>[
          Expanded(
            child: Icon(this.data.icon),
          ),
          Text(
            this.data.title,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
      ),
    );
  }
  
}