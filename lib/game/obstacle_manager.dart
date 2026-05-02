import 'dart:math';
import 'package:flame/components.dart';
import 'package:lets_jump/game/lets_jump_game.dart';
import 'package:lets_jump/game/obstacle.dart';

class ObstacleManager extends Component with HasGameRef<LetsJumpGame> {
  late Timer timer;
  final Random random = Random();

  ObstacleManager() {
    timer = Timer(
      2.0,
      onTick: _spawnObstacle,
      repeat: true,
    );
  }

  void _spawnObstacle() {
    if (gameRef.isGameOver) return;
    
    final type = ObstacleType.values[random.nextInt(ObstacleType.values.length)];
    final obstacle = Obstacle(type: type);
    
    obstacle.position = Vector2(
      gameRef.size.x + 100,
      gameRef.size.y * 0.9,
    );
    gameRef.add(obstacle);
    
    // Randomize next spawn time based on speed
    timer.limit = 1.0 + random.nextDouble() * (2.0 - (gameRef.gameSpeed / 1000).clamp(0, 1.5));
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
  }

  void reset() {
    gameRef.children.whereType<Obstacle>().forEach((o) => o.removeFromParent());
    timer.stop();
    timer.start();
  }
}
