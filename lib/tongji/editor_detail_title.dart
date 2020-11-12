import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/widget/rating_bar_box.dart';

class EditorDetailTitleWidget extends StatelessWidget{
  // 接收外部参数
  final params;
  final double width;
  final double height;
  final Color shadowColor;
  final Color backGroudColor;
  final TitleDetail data;
  final double aspectRatio;
  EditorDetailTitleWidget(this.data,{Key key,this.width,this.shadowColor,this.aspectRatio,this.height,this.backGroudColor,this.params}):super(key:key);
  double getAspectRatio(){
    return aspectRatio!=null?aspectRatio:1;
  }
  @override
  Widget build(BuildContext context) {
    double _padding =10;
    var screenW = width!=null?width:MediaQuery.of(context).size.width;
    var imgW = screenW / 4;
    var imgH = imgW * 421 / 297;
    if (height!=null) {
      imgH=height-_padding;
      imgW=imgH*0.382;
    }
    
    return Container(
      color: backGroudColor,
      padding: EdgeInsets.all(_padding),
      width: screenW,
      height: height!=null?height:screenW/getAspectRatio(),
      child: Row(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))
            ),
            color: shadowColor!=null?shadowColor:Color(0xffffffff),
            clipBehavior: Clip.antiAlias,
            elevation: 10.0,
            child: Image.network(
              data.imgUrl,
              fit: BoxFit.cover,
              width: imgW,
              height: imgH,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10,top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.title,
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        data.content,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  RatingBarBox(stars: data.star,titles:App.config["title"],width: 120,fontSize: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
}
class TitleDetail{
  String title;
  String content;
  String imgUrl;
  final star;
  TitleDetail(this.title,this.content,this.imgUrl,this.star);
}