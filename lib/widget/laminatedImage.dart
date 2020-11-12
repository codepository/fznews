import 'package:flutter/material.dart';
import 'package:fznews/app.dart';

///层叠的图片，三张图片层叠显示
class LaminatedImage extends StatelessWidget{
  final urls;
  final imageWidth;
  final int number;
  final double width;
  LaminatedImage(this.width,{Key key,this.number, @required this.urls, this.imageWidth}):super(key:key);

  List<Widget> getItems(BuildContext context,leftdif) {
    List<Widget> items=List();
    double dif = imageWidth * 0.3;
    int num = 3;
    if (number!=null) {
      num = number;
    }
    if (width!=null) {
      num = (width-imageWidth)~/dif + 1;
    }
    if (num>urls.length){
      num = urls.length;
    }
    // print("width:$width,num:$num,WIDTH:${leftdif * num + imageWidth},MEDIA:${MediaQuery.of(context).size.width}");
    for (var i=num-1;i>=0;i--){
      double height = 1.5*imageWidth - i*dif / 2;
      if (height<this.imageWidth){
        height=this.imageWidth;
      }
      // // print("height:$height");
      items.add(
        Positioned(
            left:leftdif*i,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              child: urls[i]!=null&&urls[i]!=""?Image.network(
                urls[i],
                width: imageWidth,
                height: height,
                fit: BoxFit.cover,
                color: Color.fromARGB(100, 246, 246, 246),
                colorBlendMode: BlendMode.screen,
              ):Image.asset(App.ASSEST_IMG+'/ic_default_img_subject_movie.9.png'),
            ),
        ),
      );
    }
    return items;
  }
  @override
  Widget build(BuildContext context) {
    double h = imageWidth * 1.5;
    double leftdif = imageWidth * 0.5;
    return Container(
      height: h,
      width: width,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: getItems(context,leftdif),
      ),
    );
  }
    //圆角图片
  getImage(var imgUrl, var w, var h) {
    return Card(
      child: Image.network(
        imgUrl,
        width: w,
        height: h,
        fit: BoxFit.cover,
      ),
    );
  }
}