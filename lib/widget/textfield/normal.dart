import 'package:flutter/material.dart';

class TextFieldNormal extends StatelessWidget{
  final labelText;
  final helperText;
  final textEditingController;
  final Icon icon;
  final onchange;
  TextFieldNormal({Key key,this.labelText,this.helperText,
    this.textEditingController,this.icon,
    this.onchange,
    }):assert(textEditingController!=null),super(key:key);
  void _textChanged(var str){
    onchange(str);
    
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(3.0),
          icon: icon!=null?icon:Icon(Icons.text_fields),
          labelText: labelText,
          helperText: helperText
        ),
        onChanged: _textChanged,
        autofocus: false,
        
      ),
    );
  }
  
}