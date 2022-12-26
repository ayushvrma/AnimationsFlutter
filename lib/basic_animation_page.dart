import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimationPage extends StatefulWidget {
  const AnimationPage({Key? key}) : super(key: key);

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> animation;

// Tweeens are like modifiers for an application.
// They can change its range or even output type.

  @override
  void initState() {
    super.initState();
    animController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    final curvedAnimation = CurvedAnimation(
        parent: animController,
        curve: Curves.bounceIn,
        reverseCurve: Curves.easeOut);

// every animation exposes a listener. add listener with cascade operator

// if you want same animation for forward and backward, use CurvedTween instead of curvedAnimation
    /// like this

    // animation = Tween<double>(begin: 0, end: 2 * math.pi)
    //     .chain(CurveTween(curve: Curves.bounceIn))
    //     .animate(curvedAnimation)
    //   ..addListener(() {
    //     setState(() {});
    //   })
    //   ..addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {
    //       animController.reverse();
    //     } else if (status == AnimationStatus.dismissed) {
    //       animController.forward();
    //     }
    //   });

    animation =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              animController.forward();
            }
          });
    animController
        .forward(); //goes from start value to end value. For the initial forward
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.lightBlue,
      child: Transform.rotate(
        angle: animation.value,
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: Image.asset('assets/vinyl.png')),
      ),
    ));
  }

  @override
  void dispose() {
    animController.dispose(); // very important
    super.dispose();
  }
}
