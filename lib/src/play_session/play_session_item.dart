import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutorial/src/game_internals/level_card.dart';
import 'package:tutorial/src/game_internals/level_constants.dart';

class PlaySessionItem extends StatelessWidget {

  final LevelCard levelCard;
  final bool readOnly;
  final bool facedUp;
  final bool selected;
  final Function()? onPressed;

  const PlaySessionItem({
    Key? key,
    required this.levelCard,
    this.readOnly = false,
    this.facedUp = false,
    this.selected = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.yellow.shade200,
          padding: EdgeInsets.all(5.0),
        ),
        onPressed: !readOnly && onPressed != null ? onPressed : null,
        child: Builder(
            builder: (context) {
              if (facedUp) {
                return SvgPicture.asset(
                  levelCard.getShape(),
                  color: levelCard.color,
                );
              } else if (selected) {
                return SvgPicture.asset(
                  blankSvg,
                  color: Colors.green.shade600,
                );
              }
              return SvgPicture.asset(
                blankSvg,
                color: Colors.yellow.shade700,
              );
            }
        ),
      ),
    );
  }
}
