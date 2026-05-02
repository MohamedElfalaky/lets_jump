import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:lets_jump/game/lets_jump_game.dart';

class GameHud extends PositionComponent with HasGameRef<LetsJumpGame> {
  late TextComponent scoreText;
  late TextComponent speedText;

  @override
  Future<void> onLoad() async {
    scoreText = TextComponent(
      text: 'SCORE: 0',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(blurRadius: 4, color: Colors.black)],
        ),
      ),
      position: Vector2(20, 40),
    );

    speedText = TextComponent(
      text: 'SPEED: 30',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(20, 70),
    );

    add(scoreText);
    add(speedText);
    
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    scoreText.text = 'SCORE: ${gameRef.score.toInt()}';
    speedText.text = 'SPEED: ${(gameRef.gameSpeed / 10).toInt()}';
  }
}
