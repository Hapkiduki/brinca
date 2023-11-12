import 'package:brinca/game/game.dart';
import 'package:flutter/material.dart';

class Lives extends StatelessWidget {
  const Lives({super.key, required this.gameRef});

  final TinyGame gameRef;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: gameRef.owlet.life,
      builder: (context, value, child) {
        List<Widget> list = [];
        for (int i = 0; i < 3; i++) {
          list.add(Icon(
            Icons.favorite,
            color: i < value ? Colors.red : Colors.blueGrey,
            size: gameRef.size.y / 10,
          ));
        }
        return Padding(
          padding: EdgeInsets.only(
            top: gameRef.size.y - gameRef.size.y * 88 / 100,
            right: gameRef.size.x - gameRef.size.x * 95 / 100,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: list,
          ),
        );
      },
    );
  }
}
