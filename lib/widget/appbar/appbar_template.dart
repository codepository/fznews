// import 'package:flutter/material.dart';
// import 'package:fznews/widget/appbar/basic.dart';

// class AppBarTemplate {
//   // 参数choices,是
//   static Widget basic(List<Choice> choices){
//     return AppBar(
//           title: const Text('Basic AppBar'),
//           actions: <Widget>[
//             new IconButton( // action button
//               icon: new Icon(choices[0].icon),
//               onPressed: () { _select(choices[0]); },
//             ),
//             new IconButton( // action button
//               icon: new Icon(choices[1].icon),
//               onPressed: () { _select(choices[1]); },
//             ),
//             new PopupMenuButton<Choice>( // overflow menu
//               onSelected: _select,
//               itemBuilder: (BuildContext context) {
//                 return choices.skip(2).map((Choice choice) {
//                   return new PopupMenuItem<Choice>(
//                     value: choice,
//                     child: new Text(choice.title),
//                   );
//                 }).toList();
//               },
//             ),
//           ],
//         );
//   }
// }
// class Choice {
//   const Choice({ this.title, this.icon });
//   final String title;
//   final IconData icon;
// }