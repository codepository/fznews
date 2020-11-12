import 'package:flutter/material.dart';

class WebFlowCard extends StatelessWidget{
  final shadowColor;
  final width;
  // 统计的总天数
  final int days;
  final int pvCount;
  final int visitorCount;
  final int base =10000;
  WebFlowCard({Key key,this.shadowColor,this.width,this.days,this.pvCount,this.visitorCount}):assert(days!=null,pvCount!=null),super(key:key);
  double getBarWidth(int number,double width){
    var res = number / (base*days) * width;
    if (res>width) {
      res=width;
    }
    return res;
  }
  @override
  Widget build(BuildContext context) {
    var w = width!=null?width:250;
    var barHeight=25.0;
    var barBackGroudColor=Colors.grey;
    var barColor = Colors.lightBlue;
    var textStyle = TextStyle(
      fontSize: 15,
      color: Colors.white
    );
    return Container(
      width: w,
      child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: w,
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: barBackGroudColor,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(6.0))
                  )
                ),
                Container(
                    width: getBarWidth(pvCount,w),
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: barColor,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(6.0))
                    )
                  ),
                Text(
                    '点击量:$pvCount' ,
                    style: textStyle
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            Stack(
              children: <Widget>[
                Container(
                  width: w,
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: barBackGroudColor,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(6.0))
                  )
                ),
                Container(
                    width: getBarWidth(visitorCount,w),
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: barColor,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(6.0))
                    ),
                  ),
                Text(
                  '访客数:$visitorCount' ,
                  style: textStyle
                ),
              ],
            ),
          ],
        ),
    );
  }
  
}
