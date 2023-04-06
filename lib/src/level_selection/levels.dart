// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

const gameLevels = [
  GameLevel(
    number: 1,
    grid: 2,
    selections: 1,
    goal: 1,
    points: 1,
  ),
  GameLevel(
    number: 2,
    grid: 3,
    selections: 2,
    goal: 1,
    points: 1,
  ),
  GameLevel(
    number: 3,
    grid: 4,
    selections: 2,
    goal: 1,
    points: 1,
  ),
  GameLevel(
    number: 4,
    grid: 5,
    selections: 2,
    goal: 1,
    points: 1,
  ),
];

class GameLevel {
  final int number;
  final int grid;
  final int selections;
  final int goal;
  final int points;

  final String? achievementIdIOS;
  final String? achievementIdAndroid;
  bool get awardsAchievement => achievementIdAndroid != null;

  const GameLevel({
    required this.number,
    required this.grid,
    required this.selections,
    required this.goal,
    required this.points,
    this.achievementIdIOS,
    this.achievementIdAndroid,
  }) : assert((achievementIdAndroid != null && achievementIdIOS != null) ||
                (achievementIdAndroid == null && achievementIdIOS == null),
            'Either both iOS and Android achievement ID must be provided, '
            'or none');
}
