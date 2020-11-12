import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget{
  final callback;
  final width;
  final Color backgroudColor;
  final bool readOnly;
  SearchBox({Key key,this.callback,this.width,this.backgroudColor,this.readOnly}):super(key:key);
  @override
  Widget build(BuildContext context) {

    return Container(
      //修饰黑色背景与圆角
      decoration: BoxDecoration(
        color: backgroudColor!=null?backgroudColor:Colors.white,
        borderRadius: BorderRadius.circular(24.0),
      ),
      alignment: AlignmentDirectional.center,
      height: 36,
      width: width!=null?width:200,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
      child: TextField(
        readOnly: readOnly,
        onTap: (){
          if(callback!=null){
            this.callback();
          }
        },
        cursorColor: Color.fromARGB(255, 0, 189, 96),
        style: TextStyle(fontSize: 17),
        decoration: InputDecoration(
          // contentPadding: const EdgeInsets.all(8.0),
          border: InputBorder.none,
          // hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 17, color: Color.fromARGB(255, 192, 191, 191)
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 25,
            color: Color.fromARGB(255, 128, 128, 128),
          )
      ),
      )
    );
  }
  
}