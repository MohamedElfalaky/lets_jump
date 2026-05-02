import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:lets_jump/game/lets_jump_game.dart';

enum ObstacleType { small, tall, wide }

class Obstacle extends SpriteComponent with HasGameReference<LetsJumpGame>, CollisionCallbacks {
  final ObstacleType type;

  Obstacle({required this.type}) : super(size: Vector2(60, 60), anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    try {
      final spritePath = 'obstacles/${type.name}.png';
      sprite = await game.loadSprite(spritePath);
    } catch (e) {
      sprite = await game.loadSprite('obstacles/block.png');
    }

    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= game.gameSpeed * dt;

    if (position.x < -size.x) {
      removeFromParent();
    }
  }
}
