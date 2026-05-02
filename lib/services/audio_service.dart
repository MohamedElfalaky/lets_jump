import 'package:flame_audio/flame_audio.dart';

class AudioService {
  static bool _enabled = true;

  static Future<void> init() async {
    // Preload sounds
    // Note: Files must exist in assets/audio/
    try {
      await FlameAudio.audioCache.loadAll([
        'jump.mp3',
        'game_over.mp3',
        'music.mp3',
      ]);
    } catch (e) {
      _enabled = false;
      print('Audio files not found, audio disabled');
    }
  }

  static void playJump() {
    if (!_enabled) return;
    FlameAudio.play('jump.mp3', volume: 0.5);
  }

  static void playGameOver() {
    if (!_enabled) return;
    FlameAudio.play('game_over.mp3', volume: 0.6);
  }

  static void startBgm() {
    if (!_enabled) return;
    FlameAudio.bgm.play('music.mp3', volume: 0.3);
  }

  static void stopBgm() {
    if (!_enabled) return;
    FlameAudio.bgm.stop();
  }
}
