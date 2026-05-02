import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:lets_jump/game/lets_jump_game.dart';

class BeautifulBackground extends Component with HasGameReference<LetsJumpGame> {
  final List<_Star> _stars = List.generate(100, (_) => _Star());
  final Random _random = Random();

  @override
  void render(Canvas canvas) {
    final size = game.size;
    
    // 1. Draw a deep space gradient background
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF0F2027),
          const Color(0xFF203A43),
          const Color(0xFF2C5364).withOpacity(0.8),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    // 2. Draw procedural stars
    for (var star in _stars) {
      final starPaint = Paint()
        ..color = Colors.white.withOpacity(star.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, star.size * 0.5);
      
      canvas.drawCircle(
        Offset(star.x * size.x, star.y * size.y),
        star.size,
        starPaint,
      );
    }

    // 3. Draw atmospheric glows
    _drawGlow(canvas, size, const Offset(0.2, 0.3), Colors.cyanAccent.withOpacity(0.05), 200);
    _drawGlow(canvas, size, const Offset(0.8, 0.7), Colors.purpleAccent.withOpacity(0.05), 300);

    // 4. Draw distant procedural mountains
    _drawMountains(canvas, size);
  }

  void _drawMountains(Canvas canvas, Vector2 size) {
    final path = Path();
    path.moveTo(0, size.y * 0.9);
    
    // Create a jagged mountain line
    for (var i = 0; i <= 10; i++) {
      final x = size.x * (i / 10);
      final y = size.y * 0.7 + (sin(i * 2 + (game.score * 0.05)) * 20);
      path.lineTo(x, y);
    }
    
    path.lineTo(size.x, size.y * 0.9);
    path.close();

    final paint = Paint()
      ..color = const Color(0xFF1A2A3A).withOpacity(0.5)
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(path, paint);
  }

  void _drawGlow(Canvas canvas, Vector2 size, Offset position, Color color, double radius) {
    final paint = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.5);
    canvas.drawCircle(Offset(position.dx * size.x, position.dy * size.y), radius, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Slowly move stars for a parallax effect
    for (var star in _stars) {
      star.x -= dt * (star.size * 0.01) * (game.gameSpeed / 100);
      if (star.x < 0) {
        star.x = 1.0;
        star.y = _random.nextDouble();
      }
      
      // Twinkle effect
      star.opacity += (star.twinkleSpeed * dt);
      if (star.opacity > 0.8 || star.opacity < 0.2) {
        star.twinkleSpeed *= -1;
      }
    }
  }
}

class _Star {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double size = 1.0 + Random().nextDouble() * 2.0;
  double opacity = 0.2 + Random().nextDouble() * 0.6;
  double twinkleSpeed = 0.2 + Random().nextDouble() * 0.5;
}
