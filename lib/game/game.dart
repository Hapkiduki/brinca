import 'dart:async';

import 'package:brinca/game/owlet.dart';
import 'package:brinca/utils/enemy_generator.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class TinyGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Owlet owlet;
  late ParallaxComponent parallaxComponent;
  late EnemyGenerator enemyGenerator;
  late TextComponent scoreComponent;
  late TextComponent scoreTitle;
  late double score;

  bool isPaused = false;
  double currentSpeed = .2;

  TinyGame() {
    enemyGenerator = EnemyGenerator();
    scoreComponent = TextComponent();
    scoreTitle = TextComponent();
  }

  @override
  FutureOr<void> onLoad() async {
    owlet = await Owlet.create();
    parallaxComponent = await loadParallaxComponent(
      [
        ParallaxImageData('background/Layer_0011_0.png'),
        ParallaxImageData('background/Layer_0010_1.png'),
        ParallaxImageData('background/Layer_0009_2.png'),
        ParallaxImageData('background/Layer_0008_3.png'),
        ParallaxImageData('background/Layer_0007_Lights.png'),
        ParallaxImageData('background/Layer_0006_4.png'),
        ParallaxImageData('background/Layer_0005_5.png'),
        ParallaxImageData('background/Layer_0004_Lights.png'),
        ParallaxImageData('background/Layer_0003_6.png'),
        ParallaxImageData('background/Layer_0002_7.png'),
        ParallaxImageData('background/Layer_0001_8.png'),
        ParallaxImageData('background/Layer_0000_9.png'),
      ],
      baseVelocity: Vector2(currentSpeed, 0),
      velocityMultiplierDelta: Vector2(1.8, 1.0),
    );

    score = 0;
    scoreTitle = TextComponent(
      text: 'Score',
      textRenderer: TextPaint(
        style: TextStyle(fontSize: size.y - size.y * 90 / 100),
      ),
    );

    scoreComponent = TextComponent(
      text: score.toStringAsFixed(0),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: TextStyle(
            fontSize: size.y - size.y * 94 / 100, color: Colors.yellow),
      ),
    );

    addAll([
      parallaxComponent,
      owlet,
      owlet.dust,
      enemyGenerator,
      scoreTitle,
      scoreComponent,
    ]);

    overlays.add('Pause Button');
    overlays.add("Lives");

    onGameResize(canvasSize);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    scoreTitle.x = (size.x - scoreComponent.width - scoreTitle.width) / 2;
    scoreTitle.y = size.y - size.y * 88 / 100;

    scoreComponent.x = (size.x - scoreComponent.width) / 2;
    scoreComponent.y = size.y - size.y * 75 / 100;
    super.onGameResize(size);
  }

  @override
  void update(double dt) {
    gameOver();
    score += 60 * dt;
    scoreComponent.text = score.toStringAsFixed(0);

    if (owlet.onGround) {
      owlet.dust.runDust();
    }
    if (!owlet.onGround) {
      owlet.dust.jumpDust();
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownInfo info) {
    owlet.jump();
    super.onTapDown(info);
  }

  void gameOver() async {
    if (owlet.life.value < 1) {
      enemyGenerator.removeAllEnemy();
      scoreComponent.removeFromParent();
      scoreTitle.removeFromParent();
      owlet.die();
      await Future.delayed(const Duration(milliseconds: 500));
      overlays.add('Game Over');
      pauseEngine();
    }
  }
}
