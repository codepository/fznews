import 'package:flutter/material.dart';

class ChoiceCard extends StatelessWidget {
  final title;
  final icon;
  ChoiceCard({ Key key, this.title,this.icon }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return new Card(
      color: Colors.white,
      child: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Icon(icon, size: 128.0, color: textStyle.color),
            new Text(title, style: textStyle),
          ],
        ),
      ),
    );
  }
}
typedef Widget HandlerFunc();
class Choice {
  const Choice({ this.title, this.icon, this.activeIcon,this.handler });
  final String title;
  final IconData icon;
  final IconData activeIcon;
  // HandlerFunc 必须返回widget
  final HandlerFunc handler;
}