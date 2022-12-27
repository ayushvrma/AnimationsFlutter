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
      child: RotatingTransition(
          angle: animation,
          child:
              DiskImage()), // can also use pre built RotationTransition that takes turns instead of angle
    ));
  }

  @override
  void dispose() {
    animController.dispose(); // very important
    super.dispose();
  }
}

class RotatingTransition extends StatelessWidget {
  RotatingTransition({required this.angle, required this.child});

  late final Widget child; // container holding the image
  late final Animation<double> angle;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: angle,
      builder: (context, child) {
        return Transform.rotate(
            // seperated animation motion into a seperate Widget (rotating transition), which can be used with any Widget.
            angle: angle.value,
            child: child); // to optimise the perfomance of the app
      },
      child: child,
    );
  }
}

class DiskImage extends StatelessWidget {
  // now we can get this listenable from the super class
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        child: Image.asset('assets/vinyl.png'));
  }
}
