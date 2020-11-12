import 'package:flutter/material.dart';
import 'package:fznews/widget/rating_bar.dart';

class RatingBarBox extends StatelessWidget{
  final stars;
  final text;
  final width;
  final fontSize;
  final List<dynamic> titles;
  RatingBarBox({Key key,this.stars,this.text,this.width,this.fontSize,this.titles}):assert(stars!=null),super(key:key);
  Color getColor(){
    if (stars>8){
      return Color.fromARGB(80,251,80,33);
    }
    if (stars>6){
      return Color.fromARGB(80,251,110,33);
    }
    if (stars>4){
      return Color.fromARGB(80,251,140,33);
    }
    if (stars>2){
      return Color.fromARGB(50,251,180,33);
    }
    if (stars>1){
      return Color.fromARGB(50,251,200,33);
    }
    return Color(0x23000000);
  }
  @override
  Widget build(BuildContext context) {
    String _text;
    var _stars=this.stars;
    if (this.stars>10){
      _stars=10;
    }
    if (titles!=null){
      var index=_stars~/2;
      if (index>5)index=5;
      if (index==0) index=1;
      _text=titles[index-1];
    }else{
      _text="称号";
    }
    return Container(
      width: width,
      // alignment: Alignment(0,3),
      decoration: BoxDecoration(
        color: getColor(),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(5,0,0,0),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              //评分、星星
              children: <Widget>[
                Text(
                  '$_text $stars',
                  style: TextStyle(fontSize: fontSize==null?20.0:fontSize, color: Colors.black26,fontWeight: FontWeight.bold),
                ),
                RatingBar(
                  _stars,
                  size: fontSize==null?20.0:fontSize,
                  fontSize: 0.0,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  
}