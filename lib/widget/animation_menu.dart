import 'package:flutter/material.dart';

class AnimationMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimationMenuState();
  }
}

class _AnimationMenuState extends State<AnimationMenu> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: 300.0, end: 50.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Icon(
          Icons.home,
          size: animation.value,
        )
      ],
    );
  }
}
