// import 'package:flutter/material.dart';
// import 'package:fznews/app.dart';
// import 'package:fznews/chart/pie.dart';
// import 'package:fznews/http/API.dart';
// import 'dart:convert';

// // 量化计分页面
// class QuantitativeScoringPage extends StatelessWidget{
//   final params;
//   QuantitativeScoringPage({Key key,this.params}):super(key:key);
//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('量化计分'),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.fromLTRB(0,10,0,20),
//                 child: Text(
//                   '量化计分占比',
//                   style: TextStyle(
//                     fontSize: 20
//                   ),
//                 ),
//               ),
//               Container(
//                 child: Column(
//                   children: <Widget>[
//                     ScoreRatio(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// class ScoreRatio extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() {

//     return ScoreRatioState();
//   }

// }
// class ScoreRatioState extends State<ScoreRatio> {
//   bool loading = true;
//   int touchedIndex;
//   List<PieData> pieDatas;
//   @override
//   void initState(){
//     super.initState();
//     requestAPI();
//   }
//   void requestAPI() async {
//     Map<String,List<dynamic>> ratios;
//     Future(()=>(App.request.post(API.findAllInfoDic, {"type2": "量化计分占比"}))).then((value){
//       var result = value["message"];
//       if (result.length==0){
//         return;
//       }
//       ratios=Map();
//       result.forEach((item){
//         if (ratios[item["name"]]==null){
//           ratios[item["name"]] = List();
//         }
//         ratios[item["name"]].add(item);
//       });
//       List<PieData> _pies = List();
//       ratios.forEach((key, items){
//         var piedata = PieData();
//         piedata.title = key;
//         items.forEach((item){
//           piedata.legend.add(item['type']);
//           piedata.data.add(PieItem(name: item['type'],value: item['value']));
//         });
//         _pies.add(piedata);
//       });
//       this.pieDatas = _pies;
//       setState(() {
//         this.loading = false;
//       });

//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: loading ? Container(child: Text('加载中'),):Column(
//           children: pieDatas.map((item)=>chartContainer(item)).toList(),
//         ),
//     );
//   }
//   Widget chartContainer(PieData piedata) {
//     return AspectRatio(
//       aspectRatio: 1.3,
//       child: Card(
//         child: getEchart(piedata),
//       ),
//     );
//   }
//   Widget getEchart(PieData data){
//     return Echarts(
//                         option: '''
//                         {
//                           title: {
//                               text: ${jsonEncode(data.title)},
//                               left: 'left'
//                           },
//                           tooltip: {
//                               trigger: 'item',
//                               formatter: '{a} <br/>{b}: {c} ({d}%)'
//                           },
//                           series: [
//                               {
//                                   name: ${jsonEncode(data.title)},
//                                   type: 'pie',
//                                   radius: ['50%', '70%'],
//                                   center: ['50%', '60%'],
//                                   label: {
//                                       position: 'inner',
//                                       alignTo: 'none',
//                                       margin: 5
//                                   },

//                                   emphasis: {
//                                       label: {
//                                           show: true,
//                                           fontSize: '10',
//                                           fontWeight: 'bold'
//                                       }
//                                   },
//                                   labelLine: {
//                                       show: false
//                                   },
//                                   data: ${jsonEncode(data.data)}
//                               }
//                           ]
//                       }
//                         ''',
//                       );
//   }
// }
