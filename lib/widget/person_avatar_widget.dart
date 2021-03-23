import 'package:flutter/material.dart';

class PersonAvatar {
  String name;
  String avatar;
  PersonAvatar(this.name, this.avatar);
}

class PersonAvatarWidget extends StatelessWidget {
  final double width;
  final double height;
  final PersonAvatar data;
  PersonAvatarWidget({this.width, this.height, this.data}) : assert(data != null);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 60,
      height: height ?? 60,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(data.avatar),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "${data.name}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
