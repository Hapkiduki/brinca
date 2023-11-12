import 'package:brinca/game/enemy.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';

import 'package:flutter/material.dart' as mt;

import 'dust.dart';

class Owlet extends SpriteAnimationComponent with CollisionCallbacks {
  late Dust dust; // Dust of the Owlet

  static late SpriteAnimation _idleAnimation;
  static late SpriteAnimation _runAnimation;
  static late SpriteAnimation _hurtAnimation;
  static late SpriteAnimation _deathAnimation;

  static const gravity = 1000;
  late double speedY, initialV;
  late mt.ValueNotifier<int> life;
  late Timer _timer;
  double skyToGround = 0.0;
  bool isHit = false;

  Owlet() {
    life = mt.ValueNotifier(3);
    _timer = Timer(
      1,
      onTick: () {
        isHit = false;
        run();
      },
    );
  }

  static Future<Owlet> create() async {
    final owl = Owlet();
    Image owletIdleImage =
        await Flame.images.load('owlet_monster/Owlet_Monster_Jump_8.png');
    final idleSprite =
        SpriteSheet(image: owletIdleImage, srcSize: Vector2.all(32));
    _idleAnimation = idleSprite.createAnimation(row: 0, stepTime: .1);

    // Run Animation initialization
    Image owletRunImage =
        await Flame.images.load('owlet_monster/Owlet_Monster_Run_6.png');
    final runSprite =
        SpriteSheet(image: owletRunImage, srcSize: Vector2(32, 32));
    _runAnimation = runSprite.createAnimation(row: 0, stepTime: 0.1);

    // Hurt Animation initialization
    Image owletHurtImage =
        await Flame.images.load('owlet_monster/Owlet_Monster_Hurt_4.png');
    final hurtSprite =
        SpriteSheet(image: owletHurtImage, srcSize: Vector2(32, 32));
    _hurtAnimation = hurtSprite.createAnimation(row: 0, stepTime: 0.1);

    // Death Animation initialization
    Image owletDeathImage =
        await Flame.images.load('owlet_monster/Owlet_Monster_Death_8.png');
    final deathSprite =
        SpriteSheet(image: owletDeathImage, srcSize: Vector2(32, 32));
    _deathAnimation = deathSprite.createAnimation(row: 0, stepTime: 0.1);

    owl.animation = _runAnimation;

    owl.dust = await Dust.create();
    return owl;
  }

  @override
  void onGameResize(Vector2 size) {
    speedY = initialV = -200 - (size.y);
    height = width = size.y / 7;
    x = size.x - size.x * 81 / 100;
    y = size.y - size.y * 24 / 100;
    skyToGround = y;
    super.onGameResize(size);
  }

  @override
  void onMount() {
    add(RectangleHitbox.relative(Vector2(.6, .8), parentSize: size));
    super.onMount();
  }

  @override
  void update(double dt) {
    speedY += gravity * dt;
    var distance = speedY * dt;
    y += distance;

    if (onGround) {
      run();

      y = skyToGround;
      speedY = 0.0;
    }

    _timer.update(dt);

    super.update(dt);
  }

  bool get onGround => y >= skyToGround;

  void idle() {
    animation = _idleAnimation;
  }

  void run() {
    if (!isHit) {
      animation = _runAnimation;
    }
  }

  void hurt() {
    animation = _hurtAnimation;
  }

  void die() {
    animation = _deathAnimation;
  }

  void jump() {
    if (onGround) {
      !isHit ? idle() : hurt();
      idle();
      speedY = initialV;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Enemy && !isHit) {
      hurt();
      life.value -= 1;
      isHit = true;
      _timer.start();
    }
    super.onCollision(intersectionPoints, other);
  }
}
