import 'package:flutter/material.dart';

class  NewsCardWithFlow extends StatelessWidget {
  final String title;
  final String source;
  final int pvCount;
  final int visitorCount;
  final String imgUrl;
  NewsCardWithFlow({Key key,this.title,this.source,
    this.pvCount,this.visitorCount,this.imgUrl}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  this.title!=null?this.title:"NULL",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 3),),
                Row(
                  children: <Widget>[
                    Text(
                      '$source',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          this.imgUrl!=null?Image.network(
            this.imgUrl,
            width: 100,
            height: 60,
            fit:BoxFit.cover
          ):Container()
        ],
      ),
    );
  }
    
}