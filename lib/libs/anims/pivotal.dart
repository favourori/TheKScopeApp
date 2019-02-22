import 'dart:math' as math;
import 'package:flutter/material.dart';

class PivotTransition extends AnimatedWidget {
  /// Creates a rotation transition.
  ///
  /// The [turns] argument must not be null.
  PivotTransition({
    Key key,
    this.alignment: FractionalOffset.center,
    @required Animation<double> turns,
    this.child,
  }) : super(key: key, listenable: turns);

  /// The animation that controls the rotation of the child.
  ///
  /// If the current value of the turns animation is v, the child will be
  /// rotated v * 2 * pi radians before being painted.
  Animation<double> get turns => listenable;

  /// The pivot point to rotate around.
  final FractionalOffset alignment;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;
    final Matrix4 transform = new Matrix4.rotationZ(turnsValue * math.pi * 2.0);
    return new Transform(
      transform: transform,
      alignment: alignment,
      child: child,
    );
  }
}
