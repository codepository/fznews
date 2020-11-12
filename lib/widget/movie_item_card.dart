import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fznews/app.dart';
import 'package:fznews/widget/rating_bar.dart';

class MovieItemCard extends StatelessWidget{
  final String imgNetUrl;
  final title;
  final width;
  MovieItemCard(this.imgNetUrl,{Key key,this.width=150.0,this.title='未命名'}):super(key:key);
  final defaultImg = Image.asset(App.ASSEST_IMG+'/ic_default_img_subject_movie.9.png');
  // final defaultImg = Image.network(
  //   'http://wework.qpic.cn/bizmail/1rd07pC6CQuL6FOn0pOxPic3Dk7zE7NPt45a0ugszXiag78q7iaZUsltA/0'
  // );
  
  @override
  Widget build(BuildContext context) {
    // // print("imgurl:$imgNetUrl");
    var img = Image.network(imgNetUrl != null &&imgNetUrl!=null ? imgNetUrl : "http://wework.qpic.cn/bizmail/1rd07pC6CQuL6FOn0pOxPic3Dk7zE7NPt45a0ugszXiag78q7iaZUsltA/0");
    return GestureDetector(
      onTap: (){
        // print('onTap');
      },
      child: Container(
        constraints: BoxConstraints(
          maxWidth: width,
          maxHeight: 2*width,
        ),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: CachedNetworkImage(
                imageUrl: imgNetUrl,
                // imageUrl: 'http://wework.qpic.cn/bizmail/1rd07pC6CQuL6FOn0pOxPic3Dk7zE7NPt45a0ugszXiag78q7iaZUsltA/0',
                width: width,
                height: width/150.0 * 210.0,
                fit:BoxFit.fill,
                placeholder: (BuildContext context,String url){
                  return imgNetUrl!="" && imgNetUrl!=null?img:defaultImg;
                },
                fadeInDuration: Duration(microseconds: 80),
                fadeOutDuration: Duration(microseconds: 80),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Container(
                width: double.infinity,
                child: Text(
                  title,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            RatingBar(
              9,
              size:12.0,
            ),
          ],
        ),
      ),
    );
  }

}

