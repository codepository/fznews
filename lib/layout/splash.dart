import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fznews/layout/appContainer.dart';

import '../app.dart';
// 启动小部件
class SplashWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    
    return _SplashWidgetState();
  }
  
}
class _SplashWidgetState extends State<SplashWidget> {
  bool showAd = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: showAd,
          child: AppContainer(),
          // child: AppAlipay(bottoms: Routes.getRoutesList(),),
        ),
        Offstage(
          offstage: !showAd,
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                // 正中图标
                Align(
                  alignment: Alignment(0.0,0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width/3,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(App.ASSEST_IMG + 'home.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          '落花有意随流水,流水无心恋落花',
                          style: TextStyle(fontSize: 15.0, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // 倒计时标志
                      Align(
                        alignment: Alignment(1.0,1.0),
                        child: Container(
                          margin: EdgeInsets.only(right: 30.0,top: 20.0),
                          padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 2.0,bottom: 2.0),
                          decoration: BoxDecoration(
                            color: Color(0xffEDEDED),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: CountDownWidget(seconds: App.config["splash"]["count"],onCountDownFinishCallBack:(bool val){
                            if (val) {
                              setState(() {
                                showAd = false;
                              });
                            }
                          }),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              App.ASSEST_IMG + App.config["splash"]["logo"]["assets"],
                              width: App.config["splash"]["logo"]["width"],
                              height: App.config["splash"]["logo"]["height"],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                'Hi, ${App.config["splash"]["logo"]["text"]}',
                                style: TextStyle(
                                  // color: Color(App.config["splash"]["logo"]["textColor"]),
                                  color: Colors.green,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
  
}

class CountDownWidget extends StatefulWidget {
  final onCountDownFinishCallBack;
  final seconds;
  CountDownWidget({Key key,this.seconds,@required this.onCountDownFinishCallBack}):super(key:key);


  @override
  State<StatefulWidget> createState() {

    return _CountDownWidgetState();
  }
}
class _CountDownWidgetState extends State<CountDownWidget> {
  Timer _timer;
  var _seconds;
  @override
  void initState(){
    super.initState();
    _seconds = widget.seconds>0? widget.seconds : 3;
    _startTimer();
  }
  @override
  void dispose(){
    super.dispose();
    if (_timer!=null){
      _timer.cancel();
    }
  }
  @override
  Widget build(BuildContext context) {
    
    return Text(
      '$_seconds',
      style: TextStyle(fontSize: 17.0),
    );
  }
  void _startTimer(){
    _timer = Timer.periodic(Duration(seconds: 1), (timer){
      setState(() {
        
      });
      if (_seconds <= 1){
        widget.onCountDownFinishCallBack(true);
        timer?.cancel();
        return;
      }
      _seconds--;
    });
  }
  
}