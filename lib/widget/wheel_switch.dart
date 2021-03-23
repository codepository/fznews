import 'dart:math';

import 'package:flutter/material.dart';

class WheelSwitch extends StatefulWidget {
  const WheelSwitch({
    Key key,
    @required this.value,
    this.onChanged,
    this.width = 80,
    this.height = 30,
    this.activeTrackColor = Colors.blue,
    this.inactiveTrackColor = Colors.grey,
    this.activeThumbColor = Colors.blue,
    this.inactiveThumbColor = Colors.grey,
    this.activeText = 'ON',
    this.inactiveText = 'OFF',
    this.activeTextStyle = const TextStyle(color: Colors.white, fontSize: 10),
    this.inactiveTextStyle = const TextStyle(color: Colors.white, fontSize: 10),
    this.backgroundChild,
    this.duration = const Duration(milliseconds: 800),
  })  : assert(value != null, 'value cannot be null'),
        assert(duration != null, 'duration cannot be null'),
        super(key: key);

  /// 开关是开还是关，不能设置为null
  final bool value;

  /// 开关发生变化时回调
  final ValueChanged<bool> onChanged;

  /// 开关 width
  final double width;

  /// 开关 height
  final double height;

  /// 开启状态下轨道的颜色
  final Color activeTrackColor;

  /// 关闭状态下轨道的颜色
  final Color inactiveTrackColor;

  /// 开启状态下滑块的颜色
  final Color activeThumbColor;

  /// 关闭状态下滑块的颜色
  final Color inactiveThumbColor;

  /// 开启状态下滑块的文字
  final String activeText;

  /// 关闭状态下滑块的文字
  final String inactiveText;

  /// 开启状态下文字的样式
  final TextStyle activeTextStyle;

  /// 关闭状态下文字的样式
  final TextStyle inactiveTextStyle;

  /// 过度动画时长
  final Duration duration;
  // 背景子组件
  final Widget backgroundChild;
  @override
  State<StatefulWidget> createState() {
    return _WheelSwitchState();
  }
}

class _WheelSwitchState extends State<WheelSwitch> with SingleTickerProviderStateMixin {
  double _paddingHorizontal = 1.5;
  AnimationController _controller;
  bool _value;
  Animation<Color> _colorTrackAnimation;
  Animation<Color> _colorThumbAnimation;
  Animation<TextStyle> _textStyleAnimation;
  Animation<Alignment> _alignmentAnimation;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _value = widget.value;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _colorTrackAnimation = ColorTween(
            begin: widget.value ? widget.activeTrackColor : widget.inactiveTrackColor,
            end: !widget.value ? widget.activeTrackColor : widget.inactiveTrackColor)
        .animate(_controller);
    _colorThumbAnimation = ColorTween(
      begin: widget.value ? widget.activeThumbColor : widget.inactiveThumbColor,
      end: !widget.value ? widget.activeThumbColor : widget.inactiveThumbColor,
    ).animate(_controller);
    _textStyleAnimation = TextStyleTween(
      begin: !widget.value ? widget.activeTextStyle : widget.inactiveTextStyle,
      end: widget.value ? widget.activeTextStyle : widget.inactiveTextStyle,
    ).animate(_controller);
    _alignmentAnimation = AlignmentTween(
            begin: !widget.value ? Alignment.centerLeft : Alignment.centerRight,
            end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(_controller);
    super.initState();
  }

  double _computeThumbSize() {
    return min(widget.height, widget.width) - _paddingHorizontal * 2;
  }

  @override
  Widget build(BuildContext context) {
    var _thumbSize = _computeThumbSize();
    return GestureDetector(
      onTap: () {
        if (_controller.isAnimating) return;
        if (_controller.isDismissed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
        _value = !_value;
        widget.onChanged?.call(_value);
      },
      child: AnimatedBuilder(
        animation: _colorTrackAnimation,
        builder: (context, child) {
          var _text;
          if (_controller.isAnimating) {
            _text = _controller.value > 0.5 ? widget.activeText : widget.inactiveText;
          } else {
            _text = _value ? widget.activeText : widget.inactiveText;
          }
          return Stack(
            children: <Widget>[
              Container(
                width: widget.width,
                height: widget.height,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: _paddingHorizontal),
                child: widget.backgroundChild,
              ),
              Container(
                width: widget.width,
                height: widget.height,
                alignment: _alignmentAnimation.value,
                padding: EdgeInsets.symmetric(horizontal: _paddingHorizontal),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(widget.height),
                    border: Border.all(width: 1, color: _colorTrackAnimation.value)),
                child: Transform(
                  transform:
                      Matrix4.rotationZ(widget.value ? -1 * _controller.value * pi * 2 : _controller.value * pi * 2),
                  origin: Offset(_thumbSize / 2, _thumbSize / 2),
                  child: Container(
                    height: _thumbSize,
                    width: _thumbSize,
                    padding: EdgeInsets.only(left: 2, bottom: 4),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: _colorThumbAnimation.value),
                    alignment: Alignment.center,
                    child: Text('$_text', style: _textStyleAnimation.value),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
