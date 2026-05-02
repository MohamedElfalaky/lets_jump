import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:lets_jump/game/lets_jump_game.dart';

class SpeedUpIndicator extends PositionComponent with HasGameReference<LetsJumpGame> {
  @override
  Future<void> onLoad() async {
    position = game.size / 2;
    
    final text = TextComponent(
      text: 'SPEED UP!',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.yellow,
          fontSize: 40,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(blurRadius: 10, color: Colors.black)],
        ),
      ),
      anchor: Anchor.center,
    );
    add(text);

    add(OpacityEffect.fadeIn(EffectController(duration: 0.3)));
    add(MoveByEffect(Vector2(0, -50), EffectController(duration: 1.5, curve: Curves.easeOut)));
    add(OpacityEffect.fadeOut(EffectController(duration: 0.5, startDelay: 1.0)));
    add(RemoveEffect(delay: 1.5));
    
    return super.onLoad();
  }
}
