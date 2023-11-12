import 'package:brinca/screens/lives.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/game.dart';
import 'screens/game_over.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late TinyGame _game;

  @override
  void initState() {
    super.initState();
    _game = TinyGame();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      loadingBuilder: (p0) => const Center(
        child: SizedBox(
          width: 200,
          child: Material(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Loading",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  LinearProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
      game: _game,
      overlayBuilderMap: {
        'Pause Button': pauseButton,
        'Lives': (_, __) => Lives(
              gameRef: _game,
            ),
        'Game Over': (_, __) {
          return gameOver(context, _game);
        }
      },
    );
  }

  Widget pauseButton(context, game) {
    return Material(
      elevation: 100,
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
            top: _game.size.y - _game.size.y * 88 / 100,
            left: _game.size.x - _game.size.x * 95 / 100),
        child: GestureDetector(
          onTap: playPauseTapped,
          child: AnimatedIcon(
            color: Colors.white,
            size: _game.size.y / 8,
            icon: AnimatedIcons.pause_play,
            progress: _animationController,
          ),
        ),
      ),
    );
  }

  void playPauseTapped() {
    if (_game.isPaused) {
      _animationController.reverse();
      _game.resumeEngine();
      _game.isPaused = false;
    } else {
      _animationController.forward();
      _game.pauseEngine();
      _game.isPaused = true;
    }
  }
}
