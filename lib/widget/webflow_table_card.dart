import 'package:flutter/material.dart';
class WebflowTableCard extends StatelessWidget{
  final double width;
  final double height;
  final List<dynamic> data;
  final Color backGroudColor;
  // final GlobalKey _globalKey=GlobalKey();
  WebflowTableCard({Key key,this.width,this.height,this.data,this.backGroudColor}):super(key:key);
  // double getWidth()=> _globalKey.currentContext.size.width;
  // double getHeight()=> _globalKey.currentContext.size.height;
  @override
  Widget build(BuildContext context) {
    double _padding=10;
    double _width;
    // double _padding=width*0.1;
    double mediaW=MediaQuery.of(context).size.width;
    if (mediaW<width){
      _width=mediaW-4*_padding;
      // _padding=mediaW*0.1;
    }else{
      if(mediaW<2*width){
        _width=mediaW/2-4*_padding;
      } else{
        _width=width-4*_padding;
      }
      if(mediaW>2*width){
        _width=width*0.7-4*_padding;
      }
    }
    List<dynamic> items;
    if (data!=null){
      items = data;
    } else {
      items = [
        [
          ["60","40"],
          [500,290],
          [300,200],
          ["95%","80%"],
          ["00:10:49","00:02:10"]
          // [1.32,1.28]
        ],
        [
          "新旧访客占比",
          "pv_count",
          "visitor_count",
          "bounce_rate",
          "average_stay_time",
          // "average_page"
        ]
      ];
    }
    double rowHeight = height!=null? height/(items[0].length+4):40;
    // print('width:$width,mediaW:$mediaW,_width:$_width,_width/3:${_width/3},height:$height,rowHeight:$rowHeight');
    TextStyle ts= TextStyle(
      fontSize: 15
    ); 
    List<Border> borders=[
      Border.all(
        color: Colors.grey
      ),
      Border(
        left: BorderSide(
          color: Colors.grey
        ),
        right: BorderSide(
          color: Colors.grey
        ),
      )
    ];
    List<Widget> wgs=List();
    wgs.add(
      Expanded(
        child: Container(
          child: Row(
            children: <Widget>[
              Container(
                width: _width/3,
                alignment: Alignment.center,
                child: Icon(
                  Icons.people,
                  color: Colors.greenAccent,
                  size:80
                ),
              ),
              Container(
                width: _width/3,
                  decoration: BoxDecoration(
                  border: borders[1]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('新访客'),
                    Text('${items[0][0][0]}%',style: TextStyle(fontSize: 20,color: Colors.green),)
                  ],
                ),
              ),
              Container(
                width: _width/3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('新访客'),
                    Text('${items[0][0][1]}%',style: TextStyle(fontSize: 20,color: Colors.green),)
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
    wgs.addAll(
      List<Widget>.from(items[0].asMap().keys.map((index){
          // print('text:${items[1][index]},val:${items[0][index][0]},奇偶:${index%2}');
          return Container(
            height: rowHeight,
            alignment: Alignment.center,
            // padding: EdgeInsets.fromLTRB(0,5,5,5),
            decoration: BoxDecoration(
              border: borders[index%2]
            ),
            child: Row(
              children: [
                Container(
                  width: _width/3,
                  alignment: Alignment.center,
                  child: Text(
                    items[1][index],
                    style: ts,
                  ),
                ),
                Container(
                  width: _width/3,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: borders[1]
                  ),
                  child: Text(
                    '${items[0][index][0]}'
                  ),
                ),
                Container(
                  width: _width/3,
                  alignment: Alignment.center,
                  child: Text(
                    '${items[0][index][1]}'
                  ),
                ),
              ],
            ),
          );
        })).skip(1).toList()
    );
    // print("wgs.length:${wgs.length}");
    return Container(
      height: height,
      color: backGroudColor,
      padding: EdgeInsets.all(_padding),
      child: Column(
        children: wgs
       ),
    );
  }
  
}