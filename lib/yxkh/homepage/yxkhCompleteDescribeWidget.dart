import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:fznews/utils/screenUtil.dart';
import 'package:fznews/yxkh/bloc/homepageBloc.dart';

// import 'package:charts_flutter/flutter.dart' as charts;
class Sales {
  String name;
  int rate;
  Sales(this.name, this.rate);
  String toString() {
    return "{'name':$name,'rate':$rate}";
  }
}

// 月度考核提交率和审批率
class YxkhCompleteDescribeWidget extends StatelessWidget {
  final HomePageBlocImpl bloc;
  final double width;
  YxkhCompleteDescribeWidget({this.width, this.bloc}) : assert(bloc != null);
  static List<charts.Series<Sales, String>> _createRandomData(List<dynamic> data) {
    List<Sales> applyData = List();
    List<Sales> completeData = List();
    for (int i = 0; i < data[0].length; i++) {
      applyData.add(Sales(data[2][i], data[0][i]));
      completeData.add(Sales(data[2][i], data[1][i]));
    }
    return [
      charts.Series<Sales, String>(
          id: 'LINE1',
          domainFn: (Sales sales, _) => sales.name.substring(0, 5),
          measureFn: (Sales sales, _) => sales.rate,
          data: applyData,
          fillColorFn: (dynamic, _) {
            return charts.MaterialPalette.blue.shadeDefault;
          }),
      charts.Series<Sales, String>(
          id: 'LINE2',
          domainFn: (Sales sales, _) => sales.name.substring(0, 5),
          measureFn: (Sales sales, _) => sales.rate,
          data: completeData,
          fillColorFn: (dynamic sales, _) {
            return charts.MaterialPalette.gray.shadeDefault;
          }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var _width = width ?? ScreenUtils.screenW(context);
    return Container(
      width: _width,
      height: 250,
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: StreamBuilder<List<dynamic>>(
        stream: bloc.completeDescribeStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data.isEmpty) {
            return Center(
              child: Text("没有数据"),
            );
          }
          return Column(
            children: <Widget>[
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 20,
                            height: 10,
                            color: Colors.blue,
                          ),
                          Container(
                            child: Text(" 提交率  "),
                          ),
                          Container(
                            width: 20,
                            height: 10,
                            color: Colors.grey,
                          ),
                          Container(
                            child: Text(" 审批率  "),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  )
                ],
              ),
              Container(
                width: width,
                height: 200,
                child: charts.BarChart(
                  _createRandomData(snapshot.data),
                  animate: true,
                  vertical: true,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
