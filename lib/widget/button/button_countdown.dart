import 'dart:async';

import 'package:flutter/material.dart';

class ButtonCountDown extends StatefulWidget{
  final int seconds;
  final callback;
  final String text;
  final double width;
  final double elevation;
  ButtonCountDown({Key key,this.seconds,this.callback,this.text,this.width,this.elevation}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _ButtonCountDownState();
  }

}
class _ButtonCountDownState extends State<ButtonCountDown>{
  int _seconds;
  Timer _timer;
  double _width;
  String _text;
  Function _onPress;

  @override void initState(){
    super.initState();
    _width=widget.width;
    _text=widget.text;
    if (_text==null){
      _text='确定';
    }
    setSeconds();
    _onPress=onPress;
  }
  void setSeconds(){
    _seconds=widget.seconds;
    if (_seconds==null) _seconds=3;
  }
  Function onPress(){
    return (){
      if (_timer!=null)return;
      _startTimer();
      if (widget.callback!=null){
            widget.callback();
          }
    }();
  }
  void _startTimer(){
    _onPress=null;
    _text=_seconds.toString();
    setState(() {});
    _timer=Timer.periodic(Duration(seconds: 1),(timer){
      _text=_seconds.toString();
      if (_seconds<=0){
        _cancelTimer();
        _onPress=onPress;
        setSeconds();
        _text=widget.text;
        if (_text==null){
          _text='确定';
        }
        setState(() {});
        return;
      }
      setState(() {});
      _seconds--;
    });
  }
  void _cancelTimer(){
    _timer?.cancel();
    _timer=null;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        color: Colors.blue,
        child: Text(_text),
        disabledColor: Colors.grey,
        minWidth: _width,
        elevation: widget.elevation,
        disabledElevation: 0,
        onPressed: _onPress,
    );
  }
  
}