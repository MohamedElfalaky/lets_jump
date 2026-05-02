import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class SpeedUpIndicator extends TextComponent with HasGameRef {
  SpeedUpIndicator()
      : super(
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

  @override
  Future<void> onLoad() async {
    position = gameRef.size / 2;
    
    // Add pop and fade effect
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(1.5), EffectController(duration: 0.3, curve: Curves.easeOut)),
      OpacityEffect.to(0, EffectController(duration: 0.5, delay: 0.5)),
      RemoveEffect(),
    ]));
    
    return super.onLoad();
  }
}
