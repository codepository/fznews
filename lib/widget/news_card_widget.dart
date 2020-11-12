import 'package:flutter/material.dart';
import 'package:fznews/widget/webflow_card_widget.dart';

class NewsCard extends StatelessWidget{
  final NewsData data;
  NewsCard({Key key,this.data}):super(key:key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      constraints: BoxConstraints(
        maxWidth: 500,
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  this.data.title!=null?this.data.title:"NULL",
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
                      '${data.source}',
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
          Padding(padding: EdgeInsets.only(left: 16),),
          WebFlowCard(width:media/3,days: data.days,pvCount:data.pvCount,visitorCount: data.visitorCount,),
          this.data.imgUrl!=null?Image.network(
            this.data.imgUrl,
            width: 100,
            height: 60,
            fit:BoxFit.cover
          ):Container()
        ],
      ),
    );
  }
  
}
class NewsData{
  final String title;
  final String source;
  final String imgUrl;
  final int pvCount;
  final int visitorCount;
  final int days;
  NewsData({this.title,this.source,this.imgUrl,this.pvCount,this.visitorCount,this.days});
}