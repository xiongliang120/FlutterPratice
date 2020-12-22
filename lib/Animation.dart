import 'package:flutter/material.dart';

/**
 * 动画实现, 补间动画
 */
class CustomeAnimationStateWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
     return _CustomeAnimationStateFul();
  }
}

class _CustomeAnimationStateFul extends State<CustomeAnimationStateWidget>
    with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation animation;
  Animation<int> intAnim;
  @override
  initState() {
    super.initState();
    //控制动画,forward,stop, reverse.
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    controller.addListener((){ //帧监听器
      print("controller=====${controller.value}");
    });
    controller.addStatusListener((status){ //状态监听器
      print("status====$status");
    });
    //设置动画速率(匀速,匀加速等)
    var animation = CurvedAnimation(parent:controller,curve: Curves.decelerate);

    intAnim = IntTween(begin: 0,end: 200).animate(animation)
      ..addListener(() {
        setState(() { //帧状态改变后,通过setState触发UI重建
        });
      });
    controller.forward();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
            width: intAnim.value.toDouble(),
            height: intAnim.value.toDouble(),
            color: Colors.blue,
          );
  }
}