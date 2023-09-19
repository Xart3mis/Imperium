import 'package:flutter/material.dart';

class SpinningIconButton extends AnimatedWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  final AnimationController controller;
  const SpinningIconButton(
      {super.key,
      required this.controller,
      required this.iconData,
      required this.onPressed})
      : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.linearToEaseOut,
    );

    return RotationTransition(
      turns: animation,
      child: IconButton(
        icon: Icon(iconData),
        onPressed: onPressed,
      ),
    );
  }
}
