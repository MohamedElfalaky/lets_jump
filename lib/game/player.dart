import 'dart:async';
import 'dart:math';
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
  
  Player({required this.character}) : super(size: Vector2(80, 120), anchor: Anchor.bottomCenter);

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
    final bodyColor = character.color;
    final sizeX = size.x;
    final sizeY = size.y;

    // 1. Draw Cartoon Body (Torso)
    final torsoPaint = Paint()..color = bodyColor;
    final torsoRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(sizeX * 0.3, sizeY * 0.4, sizeX * 0.4, sizeY * 0.4),
      const Radius.circular(10),
    );
    canvas.drawRRect(torsoRect, torsoPaint);

    // 2. Draw Animated Legs
    final legPaint = Paint()
      ..color = bodyColor.withOpacity(0.8)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final walkCycle = sin(game.score * 10); // Simple animation based on score
    
    // Left Leg
    canvas.drawLine(
      Offset(sizeX * 0.4, sizeY * 0.8),
      Offset(sizeX * (0.3 + (walkCycle * 0.1)), sizeY * 0.95),
      legPaint,
    );
    // Right Leg
    canvas.drawLine(
      Offset(sizeX * 0.6, sizeY * 0.8),
      Offset(sizeX * (0.7 - (walkCycle * 0.1)), sizeY * 0.95),
      legPaint,
    );

    // 3. Draw Arms
    canvas.drawLine(
      Offset(sizeX * 0.3, sizeY * 0.5),
      Offset(sizeX * (0.2 - (walkCycle * 0.05)), sizeY * 0.65),
      legPaint,
    );
    canvas.drawLine(
      Offset(sizeX * 0.7, sizeY * 0.5),
      Offset(sizeX * (0.8 + (walkCycle * 0.05)), sizeY * 0.65),
      legPaint,
    );

    // 4. Draw the PHOTO HEAD (The child's face) - BIG HEAD STYLE
    final headRadius = sizeX * 0.45; // Much larger head
    final headCenter = Offset(sizeX * 0.5, sizeY * 0.15); // Move higher
    final headPath = Path()..addOval(Rect.fromCircle(center: headCenter, radius: headRadius));
    
    canvas.save();
    canvas.clipPath(headPath);
    
    // Draw the actual character photo as the head
    final headRect = Rect.fromCircle(center: headCenter, radius: headRadius);
    
    // Apply the pop filter
    final filterPaint = Paint()
      ..colorFilter = const ColorFilter.matrix([
        1.2, 0, 0, 0, 5,
        0, 1.2, 0, 0, 5,
        0, 0, 1.2, 0, 5,
        0, 0, 0, 1.0, 0,
      ]);
    
    canvas.saveLayer(headRect, filterPaint);
    
    // Get the current sprite safely
    final sprite = animationTicker?.getSprite();
    if (sprite == null) {
      canvas.restore();
      canvas.restore();
      return;
    }
    final srcSize = sprite.srcSize;
    
    // Calculate the destination rect to "Cover" the head circle
    final scale = max(headRect.width / srcSize.x, headRect.height / srcSize.y);
    final destSize = srcSize * scale;
    final destRect = Rect.fromCenter(
      center: headCenter,
      width: destSize.x,
      height: destSize.y,
    );
    
    // Draw the head image directly
    sprite.renderRect(canvas, destRect);
    
    canvas.restore();
    canvas.restore();

    // 5. Add a nice glowing border to the head
    final headBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(headCenter, headRadius, headBorder);
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
