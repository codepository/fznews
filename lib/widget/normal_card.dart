import 'package:flutter/material.dart';

class NormalCard extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String rightMsg;
  final String content;
  const NormalCard({
    Key key,
    this.imgUrl,
    this.title,
    this.content,
    this.rightMsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: imgUrl !=null ? Image.network(
              this.imgUrl,
              width: 40,
              height: 40,
            ) : CircleAvatar(
              child: Text('空'),
              maxRadius: 30,
            )
          ),
          Padding(padding: EdgeInsets.only(left: 15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      this.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      this.rightMsg,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF999999),
                      ),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 2)),
                Text(
                  this.content,
                  maxLines: 1,
                  // overflow: TextOverflow.ellipsis,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
