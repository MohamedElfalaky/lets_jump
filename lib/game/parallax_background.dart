import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:lets_jump/game/lets_jump_game.dart';

class ParallaxBackground extends ParallaxComponent<LetsJumpGame> {
  @override
  FutureOr<void> onLoad() async {
    parallax = await game.loadParallax(
      [
        ParallaxImageData('background/sky.png'),
        ParallaxImageData('background/clouds.png'),
        ParallaxImageData('background/ground.png'),
      ],
      baseVelocity: Vector2(game.gameSpeed / 10, 0),
      velocityMultiplierDelta: Vector2(1.2, 1.0),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update parallax speed based on current game speed
    parallax?.baseVelocity = Vector2(game.gameSpeed / 10, 0);
  }
}
