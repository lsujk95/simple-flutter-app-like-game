import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tutorial/src/audio/audio_controller.dart';
import 'package:tutorial/src/audio/sounds.dart';
import 'package:tutorial/src/game_internals/level_state.dart';
import 'package:tutorial/src/level_selection/levels.dart';
import 'package:tutorial/src/play_session/play_session_item.dart';
import 'package:tutorial/src/player_progress/player_progress.dart';
import 'package:tutorial/src/style/confetti.dart';

class PlaySessionScreen extends StatefulWidget {
  final GameLevel level;

  const PlaySessionScreen({
    Key? key,
    required this.level,
  }) : super(key: key);

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {

  bool _duringCelebration = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LevelState(
              level: widget.level,
              onWin: () async {
                final playerProgress = context.read<PlayerProgress>();
                playerProgress.setLevelReached(widget.level.number);

                final audioController = context.read<AudioController>();
                audioController.playSfx(SfxType.congrats);

                setState(() {
                  _duringCelebration = true;
                });

                // await Future<void>.delayed(Duration(seconds: 5));
                // setState(() {
                //   _duringCelebration = false;
                // });

              }
          ),
        ),
      ],
      child: Scaffold(
          body: Stack(
            children: [
              Builder(
                  builder: (context) {
                    final levelState = context.watch<LevelState>();
                    return WillPopScope(
                      onWillPop: () async {
                        levelState.reset();
                        return true;
                      },
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Builder(
                              builder: (context) {
                                if (levelState.status == LevelStatus.initial) {
                                  levelState.init();
                                }

                                if (levelState.status == LevelStatus.showing ||
                                    levelState.status == LevelStatus.choosing ||
                                    levelState.status == LevelStatus.win ||
                                    levelState.status == LevelStatus.lose
                                ) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 150.0,
                                                  width: 150.0,
                                                  color: Colors.yellow.shade200,
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: PlaySessionItem(
                                                    levelCard: levelState.correctSelectionCard,
                                                    facedUp: levelState.status == LevelStatus.choosing ||
                                                        levelState.status == LevelStatus.win ||
                                                        levelState.status == LevelStatus.lose,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (levelState.status == LevelStatus.showing) Center(
                                              child: Text(
                                                'Memorize the arrangement of cards.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green.shade600,
                                                ),
                                              ),
                                            ),
                                            if (levelState.status == LevelStatus.choosing) Center(
                                              child: Text(
                                                '${levelState.selectedCards.length}/${levelState.level.selections}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green.shade600,
                                                ),
                                              ),
                                            ),
                                            if (levelState.status == LevelStatus.win) Center(
                                              child: Text(
                                                'Congratulations! You marked ${levelState.correctSelections}/${levelState.level.selections} correct fields.'
                                                    + 'You get ${levelState.receivedPoints} points.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green.shade600,
                                                ),
                                              ),
                                            ),
                                            if (levelState.status == LevelStatus.lose) Center(
                                              child: Text(
                                                'Defeat! You marked ${levelState.correctSelections} correct fields. '
                                                    + 'You have to mark at least ${levelState.level.goal}/${levelState.level.selections} correct fields.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red.shade600,
                                                ),
                                              ),
                                            ),
                                            LayoutBuilder(
                                              builder: (BuildContext context, BoxConstraints constraints) {
                                                return Container(
                                                  width: constraints.maxWidth,
                                                  height: constraints.maxWidth,
                                                  child: Column(
                                                    children: [
                                                      for (int row = 0; row < levelState.level.grid; row++) Expanded(
                                                        child: Row(
                                                          children: [
                                                            for (int item = row * levelState.level.grid;
                                                            item < row * levelState.level.grid + levelState.level.grid;
                                                            item++
                                                            ) Flexible(
                                                              child: PlaySessionItem(
                                                                levelCard: levelState.currentLevelCards[item],
                                                                facedUp: levelState.status == LevelStatus.showing ||
                                                                    (levelState.selectedCards.contains(item) &&
                                                                        (levelState.status == LevelStatus.win || levelState.status == LevelStatus.lose)
                                                                    ),
                                                                selected: levelState.selectedCards.contains(item),
                                                                onPressed: () {
                                                                  if (levelState.status == LevelStatus.choosing) {
                                                                    levelState.toggleCard(item);
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (levelState.status == LevelStatus.showing) Container(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        height: 80.0,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue.shade600,
                                          ),
                                          onPressed: () => levelState.run(),
                                          child: Text(
                                            'Play',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (levelState.status == LevelStatus.choosing) Container(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        height: 80.0,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: levelState.level.selections == levelState.selectedCards.length
                                                ? Colors.green.shade600 : Colors.green.shade200,
                                          ),
                                          onPressed: () {
                                            if (levelState.level.selections == levelState.selectedCards.length) {
                                              levelState.check();
                                            }
                                          },
                                          child: Text(
                                            'Check',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (levelState.status == LevelStatus.win || levelState.status == LevelStatus.lose) Flex(
                                        direction: Axis.horizontal,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.only(top: 10.0),
                                              height: 80.0,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: levelState.level.selections == levelState.selectedCards.length
                                                      ? Colors.green.shade600 : Colors.green.shade200,
                                                ),
                                                onPressed: () {
                                                  GoRouter.of(context).pop();
                                                },
                                                child: Text(
                                                  'Return to level selection',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }

                                return Center(
                                  child: Text('Loading...'),
                                );
                              }
                          ),
                        ),
                      ),
                    );
                  }
              ),
              SizedBox.expand(
                child: Visibility(
                  visible: _duringCelebration,
                  child: IgnorePointer(
                    child: Confetti(
                      isStopped: !_duringCelebration,
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}
