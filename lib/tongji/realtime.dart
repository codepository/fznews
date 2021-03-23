// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'dart:math' as math;

// class  Realtime extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {

//     return RealtimeState();
//   }

// }
// class RealtimeState extends State<Realtime> {
//   bool isShowingMainData;
//   List<FlSpot> uv;
//   List<FlSpot> ip;
//   List<FlSpot> pv;
//   final List<int> showIndexes = const [1,3,5];
//   @override
//   void initState(){
//     super.initState();
//     isShowingMainData = false;
//     getData();
//   }
//   void getData() {
//     uv = List();
//     ip = List();
//     pv = List();
//     for (var i=1;i<24;i++) {
//       uv.add(FlSpot(
//         i.toDouble(),
//         (math.Random().nextDouble()*100).round().toDouble(),
//       ));
//       ip.add(FlSpot(
//         i.toDouble(),
//         (math.Random().nextDouble()*100).round().toDouble(),
//       ));
//       pv.add(FlSpot(
//         i.toDouble(),
//         (math.Random().nextDouble()*100).round().toDouble(),
//       ));
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     final lineBarsData = [
//       LineChartBarData(
//         showingIndicators: showIndexes,
//         spots: uv,
//         isCurved: true,
//         barWidth: 1,
//         belowBarData: BarAreaData(
//           show: true,
//         ),
//         dotData: FlDotData(show: false),
//       ),
//       LineChartBarData(
//         showingIndicators: showIndexes,
//         spots: ip,
//         isCurved: true,
//         barWidth: 1,
//         belowBarData: BarAreaData(
//           show: true,
//         ),
//         dotData: FlDotData(show: false),
//       ),
//       LineChartBarData(
//         showingIndicators: showIndexes,
//         spots: pv,
//         isCurved: true,
//         barWidth: 1,
//         belowBarData: BarAreaData(
//           show: true,
//         ),
//         dotData: FlDotData(show: false),
//       )
//     ];
//     return Scaffold(
//       body: AspectRatio(
//         aspectRatio: 1.23,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(18)),
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xff2c274c),
//                 Color(0xff46426c),
//               ],
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//             ),
//           ),
//           child: Stack(
//             children: <Widget>[
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   SizedBox(
//                     height:37,
//                   ),
//                   Text(
//                     'Unfold Shop 2018',
//                     style: TextStyle(
//                       color: Color(0xff827daa),
//                       fontSize: 16
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Text(
//                     'Monthly Sales',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 2
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(
//                     height: 37,
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.only(right: 16.0,left:6.0),
//                       child: LineChart(
//                         LineChartData(
//                           lineTouchData: LineTouchData(
//                             enabled: false,
//                           ),
//                           lineBarsData: lineBarsData,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                 ],
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.refresh,
//                   color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
//                 ),
//                 onPressed: (){
//                   setState(() {
//                     isShowingMainData = !isShowingMainData;
//                   });
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   LineChartData data1(){
//     return LineChartData(
//       lineTouchData: LineTouchData(
//         touchTooltipData: LineTouchTooltipData(
//           tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
//         ),
//         touchCallback: (LineTouchResponse touchResponse) {
//           // print(touchResponse);
//         },
//         handleBuiltInTouches: true,
//       ),
//       gridData: const FlGridData(
//         show: false,
//       ),
//       titlesData: FlTitlesData(
//         bottomTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 22,
//           margin:10,
//           getTitles: (value){
//             // print(value);
//           }
//         ),
//       ),

//     );
//   }
// }
