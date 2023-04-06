import 'package:flutter/material.dart';
import 'package:tutorial/src/game_internals/level_card.dart';

enum Shape {
  circle,
  square,
  triangle,
}

const String blankSvg = 'assets/images/shapes/blank.svg';

const Map<Shape, String> levelShapes = {
  Shape.circle: 'assets/images/shapes/circle.svg',
  Shape.square: 'assets/images/shapes/square.svg',
  Shape.triangle: 'assets/images/shapes/triangle.svg',
};

const List<LevelCard> levelCards = [
  const LevelCard(shape: Shape.circle, color: Colors.red),
  const LevelCard(shape: Shape.square, color: Colors.red),
  const LevelCard(shape: Shape.triangle, color: Colors.red),
  const LevelCard(shape: Shape.circle, color: Colors.green),
  const LevelCard(shape: Shape.square, color: Colors.green),
  const LevelCard(shape: Shape.triangle, color: Colors.green),
  const LevelCard(shape: Shape.circle, color: Colors.blue),
  const LevelCard(shape: Shape.square, color: Colors.blue),
  const LevelCard(shape: Shape.triangle, color: Colors.blue),
];
