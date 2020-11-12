import 'package:flutter/material.dart';
import 'package:fznews/widget/laminatedImage.dart';

class MoviesStackCard extends StatelessWidget{
  final urls;
  final backgroundColor;
  final title;
  final double maxWidth;
  MoviesStackCard(this.urls,this.title,{Key key,this.backgroundColor,this.maxWidth}):super(key:key);

  @override
  Widget build(BuildContext context) {
    // print('build moviestackcard:$title');

    double boxWidth = maxWidth!=null ? maxWidth :600.0;
    var mediaWidth = MediaQuery.of(context).size.width;
    if (mediaWidth<maxWidth) {
      boxWidth = mediaWidth;
    }
    if (urls==null || urls.isEmpty){
      return Container();
    }


    // // print("box:$boxWidth,media:$mediaWidth");
    return Container(
      padding: EdgeInsets.fromLTRB(10,0,0,0),
      child: Stack(
      // alignment: AlignmentDirectional(1.0,1.0),
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional(1.0,1.0),
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                  maxWidth: boxWidth,
                  maxHeight: 140.0,
                ),
                height: 120.0,
                width: boxWidth,
                decoration: BoxDecoration(
                  color: backgroundColor == null ? Color.fromARGB(255, 47, 22, 74) : backgroundColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(4.0))
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: boxWidth
                ),
                height: 140.0,
                width: boxWidth,
                margin: EdgeInsets.only(left: 13.0,bottom: 14.0),
                child: Row(
                children: <Widget>[
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        LaminatedImage( boxWidth*0.6,urls:urls,imageWidth:100.0),
                        // Positioned(
                        //   left: 90.0/3,
                        //   child: Image.asset(
                        //     'assets/images/ic_launcher.png',
                        //     width: 30.0,
                        //     height: 30.0,
                        //   ),
                        // ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(top:40.0,left: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: TextStyle(
                                
                                fontSize: 15, color: Colors.white),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(top: 6.0),
                            //   child: Text(
                            //     '全部${urls.length}',
                            //     style:
                            //         TextStyle(fontSize: 13, color: Colors.white),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: <Widget>[
                    //     Padding(
                    //       padding: EdgeInsets.only(bottom: 10.0),
                    //       child: Image.asset(
                    //         'assets/images/ic_launcher.png',
                    //         width: 15.0,
                    //         height: 15.0,
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsets.only(bottom: 10.0, right: 10.0, left: 5.0),
                    //       child: Text(
                    //         '看更多',
                    //         style: TextStyle(fontSize: 11, color: Colors.white),
                    //       ),
                    //     )
                    //   ],
                    // )
                ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
  
}