import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:lets_jump/game/lets_jump_game.dart';
import 'package:lets_jump/game/obstacle.dart';
import 'package:lets_jump/game/jump_particles.dart';
import 'package:lets_jump/models/character.dart';
import 'package:lets_jump/services/audio_service.dart';

class Player extends SpriteAnimationComponent with HasGameReference<LetsJumpGame>, CollisionCallbacks {
  final Character character;
  
  Player({required this.character}) : super(size: Vector2(100, 100), anchor: Anchor.bottomCenter);

  static const double gravity = 1500;
  static const double jumpForce = -600;
  static const double groundLevel = 0.9; // 90% of height

  double velocityY = 0;
  bool isGrounded = true;

  late SpriteAnimation runningAnimation;
  late SpriteAnimation jumpingAnimation;

  @override
  FutureOr<void> onLoad() async {
    // Helper to try loading png then jpg
    Future<Sprite> loadBestSprite(String pngPath, String jpgPath) async {
      try {
        return await game.loadSprite(pngPath);
      } catch (e) {
        return await game.loadSprite(jpgPath);
      }
    }

    // Load running animation
    final sprite1 = await loadBestSprite(character.run1Path, character.run1JpgPath);
    final sprite2 = await loadBestSprite(character.run2Path, character.run2JpgPath);
    
    runningAnimation = SpriteAnimation.spriteList(
      [sprite1, sprite2],
      stepTime: 0.15,
    );

    // Load jumping animation (single frame)
    final jumpSprite = await loadBestSprite(character.jumpPath, character.jumpJpgPath);
    jumpingAnimation = SpriteAnimation.spriteList(
      [jumpSprite],
      stepTime: 1,
    );

    animation = runningAnimation;

    // Position player
    position = Vector2(game.size.x * 0.15, game.size.y * groundLevel);

    // Add collision box
    add(RectangleHitbox(
      size: Vector2(size.x * 0.6, size.y * 0.8),
      position: Vector2(size.x * 0.2, size.y * 0.1),
    ));

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    // Create a circular clip for the photo
    final radius = size.x / 2;
    final center = size / 2;
    final path = Path()..addOval(Rect.fromCircle(center: center.toOffset(), radius: radius));
    
    canvas.save();
    canvas.clipPath(path);
    
    // Draw with a cartoon-like filter (vibrancy boost)
    final filterPaint = Paint()
      ..colorFilter = const ColorFilter.matrix([
        1.2, 0, 0, 0, 5,   // Red
        0, 1.2, 0, 0, 5,   // Green
        0, 0, 1.2, 0, 5,   // Blue
        0, 0, 0, 1.0, 0,   // Alpha
      ]);
    
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.x, size.y), filterPaint);
    super.render(canvas);
    canvas.restore(); // Restore layer
    canvas.restore(); // Restore clip

    // Add a nice white border around the circle
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center.toOffset(), radius, paint);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(size.x * 0.15, size.y * groundLevel);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isGrounded) {
      velocityY += gravity * dt;
      position.y += velocityY * dt;

      if (position.y >= game.size.y * groundLevel) {
        position.y = game.size.y * groundLevel;
        velocityY = 0;
        isGrounded = true;
        animation = runningAnimation;
      }
    }
  }

  void jump() {
    if (isGrounded) {
      velocityY = jumpForce;
      isGrounded = false;
      animation = jumpingAnimation;
      
      // Add particle effect
      game.add(JumpParticles(position: position.clone()));

      // Play jump sound
      AudioService.playJump();
    }
  }

  void reset() {
    position.y = game.size.y * groundLevel;
    velocityY = 0;
    isGrounded = true;
    animation = runningAnimation;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Obstacle) {
      game.gameOver();
    }
    super.onCollision(intersectionPoints, other);
  }
}
