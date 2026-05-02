import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:lets_jump/game/lets_jump_game.dart';

enum ObstacleType { small, tall, wide }

class Obstacle extends SpriteComponent with HasGameRef<LetsJumpGame> {
  final ObstacleType type;

  Obstacle({required this.type}) : super(anchor: Anchor.bottomCenter);

  @override
  FutureOr<void> onLoad() async {
    String spritePath;
    
    switch (type) {
      case ObstacleType.small:
        size = Vector2(60, 60);
        spritePath = 'obstacles/block.png';
        break;
      case ObstacleType.tall:
        size = Vector2(60, 100);
        spritePath = 'obstacles/tall_block.png'; // User can add this
        break;
      case ObstacleType.wide:
        size = Vector2(120, 60);
        spritePath = 'obstacles/wide_block.png'; // User can add this
        break;
    }

    // Fallback to default block if specific one doesn't exist
    try {
      sprite = await gameRef.loadSprite(spritePath);
    } catch (e) {
      sprite = await gameRef.loadSprite('obstacles/block.png');
    }
    
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= gameRef.gameSpeed * dt;

    if (position.x + size.x < 0) {
      removeFromParent();
    }
  }
}
