import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lets_jump/screens/character_selection_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Force landscape orientation for better game experience
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const LetsJumpApp());
}

class LetsJumpApp extends StatelessWidget {
  const LetsJumpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Let\'s Jump!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const CharacterSelectionScreen(),
    );
  }
}
