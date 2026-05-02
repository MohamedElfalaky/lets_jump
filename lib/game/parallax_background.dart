import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:lets_jump/game/lets_jump_game.dart';

class ParallaxBackground extends ParallaxComponent<LetsJumpGame> {
  @override
  FutureOr<void> onLoad() async {
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData('background/sky.png'),
        ParallaxImageData('background/clouds.png'),
        ParallaxImageData('background/ground.png'),
      ],
      baseVelocity: Vector2(50, 0),
      velocityMultiplierDelta: Vector2(1.5, 0),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Link parallax speed to game speed
    parallax?.baseVelocity = Vector2(gameRef.gameSpeed / 5, 0);
  }
}
