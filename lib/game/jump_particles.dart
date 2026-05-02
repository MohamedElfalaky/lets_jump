import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class JumpParticles extends ParticleSystemComponent {
  JumpParticles({required Vector2 position})
      : super(
          particle: Particle.generate(
            count: 10,
            lifespan: 0.5,
            generator: (i) => AcceleratedParticle(
              acceleration: Vector2(0, 200),
              speed: Vector2(
                (Random().nextDouble() - 0.5) * 200,
                -Random().nextDouble() * 200,
              ),
              child: CircleParticle(
                radius: 2 + Random().nextDouble() * 3,
                paint: Paint()..color = Colors.white.withOpacity(0.8),
              ),
            ),
          ),
          position: position,
        );
}
