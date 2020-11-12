import 'package:flutter/material.dart';

class DatesPicker extends StatelessWidget{
  final TextEditingController textEditingController;
  final String helperText;
  final double width;
  final callback;
  DatesPicker({Key key,this.textEditingController,this.helperText,this.width,this.callback}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
          width: width==null?140:width,
          child: TextField(
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.all(5.0),
                icon: Icon(Icons.date_range),
                helperText: helperText==null?'日期':helperText,
              ),
              onChanged: (val){
                 textEditingController.text = val;
              },
              autofocus: false,
              controller: textEditingController,
              onTap: (){
                // 调用函数打开
                  showDatePicker(
                      context: context,
                      initialDate: new DateTime.now(),
                      firstDate: new DateTime.now().subtract(new Duration(days: 30)), // 减 30 天
                      lastDate: new DateTime.now().add(new Duration(days: 30)),       // 加 30 天
                  ).then((DateTime val) {
                      // // print(val);   // 2018-07-12 00:00:00.000
                      var str = '$val';
                      str = str.substring(0,10);
                      textEditingController.text = str;
                      callback(textEditingController.text);
                  }).catchError((err) {
                      // print(err);
                  });
              },
          ),
        );
  }
  
}