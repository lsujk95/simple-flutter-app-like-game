import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tutorial/src/game_internals/level_card.dart';
import 'package:tutorial/src/game_internals/level_constants.dart';
import 'package:tutorial/src/level_selection/levels.dart';

enum LevelStatus {
  initial,
  loading,
  showing,
  choosing,
  win,
  lose,
}

class LevelState extends ChangeNotifier {
  final GameLevel level;
  final Function() onWin;

  LevelState({
    required this.level,
    required this.onWin,
  });

  LevelStatus status = LevelStatus.initial;
  LevelCard correctSelectionCard = levelCards[0];
  List<LevelCard> currentLevelCards = [];
  List<int> selectedCards = [];
  int correctSelections = 0;
  int receivedPoints = 0;


  LevelCard getRandomLevelCard({LevelCard? exclude}) {
    List<LevelCard> availableCards = List.from(levelCards);
    if (exclude != null) {
      availableCards.remove(exclude);
    }
    return availableCards[Random().nextInt(availableCards.length)];
  }

  void generateLevel() {
    correctSelectionCard = getRandomLevelCard();
    final int itemsCount = level.grid * level.grid; // 2x2=4, 3x3=9 etc.

    List<int> availablePositions = [];
    for (int index = 0; index < itemsCount; index++) {
      availablePositions.add(index);
    }

    List<int> correctShapePositions = [];
    for (int index = 0; index < level.selections; index++) {
      int randomPosition = availablePositions[Random().nextInt(availablePositions.length)];
      availablePositions.remove(randomPosition);

      correctShapePositions.add(randomPosition);
    }

    currentLevelCards = [];
    for (int index = 0; index < itemsCount; index++) {
      if (correctShapePositions.contains(index)) {
        currentLevelCards.add(correctSelectionCard);
      } else {
        currentLevelCards.add(getRandomLevelCard(exclude: correctSelectionCard));
      }
    }
  }

  void reset() {
    status = LevelStatus.initial;
    correctSelectionCard = levelCards[0];
    currentLevelCards = [];
    selectedCards = [];
    correctSelections = 0;
    receivedPoints = 0;

    notifyListeners();
  }

  void init() {
    status = LevelStatus.loading;
    notifyListeners();

    generateLevel();

    status = LevelStatus.showing;
    notifyListeners();
  }

  void run() {
    status = LevelStatus.choosing;
    notifyListeners();
  }


  void toggleCard(int index) {
    if (selectedCards.contains(index)) {
      selectedCards.remove(index);
    } else if (selectedCards.length < level.selections) {
      selectedCards.add(index);
    }
    notifyListeners();
  }

  void check() {
    correctSelections = 0;
    for (int index = 0; index < selectedCards.length; index++) {
      if (currentLevelCards[selectedCards[index]] == correctSelectionCard) {
        correctSelections++;
      }
    }
    receivedPoints = correctSelections * level.points;
    if (correctSelections >= level.goal) {
      onWin();
      status = LevelStatus.win;
    } else {
      status = LevelStatus.lose;
    }
    notifyListeners();
  }
}