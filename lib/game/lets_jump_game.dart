import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:lets_jump/game/player.dart';
import 'package:lets_jump/game/obstacle_manager.dart';
import 'package:lets_jump/game/parallax_background.dart';
import 'package:lets_jump/game/speed_up_indicator.dart';
import 'package:lets_jump/game/game_hud.dart';
import 'package:lets_jump/models/character.dart';
import 'package:lets_jump/services/score_service.dart';

class LetsJumpGame extends FlameGame with TapDetector, HasCollisionDetection {
  final Character character;
  
  LetsJumpGame({required this.character});

  late Player player;
  late ObstacleManager obstacleManager;
  late ParallaxBackground background;

  double score = 0;
  double gameSpeed = 300;
  double _lastSpeedThreshold = 300;
  bool isGameOver = false;

  @override
  FutureOr<void> onLoad() async {
    // Initialize Audio
    await AudioService.init();
    AudioService.startBgm();

    // Add Parallax Background
    background = ParallaxBackground();
    add(background);

    // Add Player
    player = Player(character: character);
    add(player);

    // Add Obstacle Manager
    obstacleManager = ObstacleManager();
    add(obstacleManager);

    // Add HUD
    add(GameHud());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isGameOver) return;

    super.update(dt);

    // Increase score based on time and speed
    score += dt * (gameSpeed / 100);
    
    // Gradually increase speed
    gameSpeed += dt * 3;

    // Check for speed up threshold
    if (gameSpeed - _lastSpeedThreshold >= 100) {
      _lastSpeedThreshold = gameSpeed;
      add(SpeedUpIndicator());
    }
  }

  @override
  void onTap() {
    if (isGameOver) return;
    player.jump();
  }

  void gameOver() {
    isGameOver = true;
    pauseEngine();
    ScoreService.saveScore(score.toInt());
    AudioService.playGameOver();
    AudioService.stopBgm();
    overlays.add('GameOver');
  }

  void reset() {
    isGameOver = false;
    score = 0;
    gameSpeed = 300;
    player.reset();
    obstacleManager.reset();
    AudioService.startBgm();
    resumeEngine();
    overlays.remove('GameOver');
  }
}
