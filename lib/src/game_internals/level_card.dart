import 'package:flutter/material.dart';
import 'package:tutorial/src/game_internals/level_constants.dart';

class LevelCard {
  final Shape shape;
  final Color color;

  const LevelCard({
    required this.shape,
    required this.color,
  });

  String getShape() {
    return levelShapes[shape]!;
  }
}