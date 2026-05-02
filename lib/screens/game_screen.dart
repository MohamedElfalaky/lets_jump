import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_jump/game/lets_jump_game.dart';
import 'package:lets_jump/models/character.dart';
import 'package:lets_jump/widgets/game_over_overlay.dart';

class GameScreen extends StatefulWidget {
  final Character character;

  const GameScreen({super.key, required this.character});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late LetsJumpGame _game;

  @override
  void initState() {
    super.initState();
    _game = LetsJumpGame(character: widget.character);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: _game,
        overlayBuilderMap: {
          'GameOver': (context, LetsJumpGame game) => GameOverOverlay(game: game),
        },
      ),
    );
  }
}
