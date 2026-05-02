import 'package:flutter/material.dart';

class Character {
  final String name;
  final String age;
  final String folderName;
  final Color color;

  Character({
    required this.name,
    required this.age,
    required this.folderName,
    required this.color,
  });

  String get run1Path => 'characters/$folderName/run1.png';
  String get run2Path => 'characters/$folderName/run2.png';
  String get jumpPath => 'characters/$folderName/jump.png';

  String get run1JpgPath => 'characters/$folderName/run1.jpg';
  String get run2JpgPath => 'characters/$folderName/run2.jpg';
  String get jumpJpgPath => 'characters/$folderName/jump.jpg';

  static List<Character> get characters => [
        Character(
          name: 'Nour', 
          age: '11 years', 
          folderName: 'nour', 
          color: Colors.black,
        ),
        Character(
          name: 'Salama', 
          age: '8 years', 
          folderName: 'salama', 
          color: const Color(0xFFFF69B4), // Hot Pink
        ),
        Character(
          name: 'Mariam', 
          age: '7 years', 
          folderName: 'mariam', 
          color: Colors.orange,
        ),
        Character(
          name: 'Abdullah', 
          age: '6 years', 
          folderName: 'abdullah', 
          color: Colors.blue,
        ),
        Character(
          name: 'Mohamed', 
          age: '5 years', 
          folderName: 'mohamed', 
          color: Colors.red,
        ),
        Character(
          name: 'Razan', 
          age: '4 years', 
          folderName: 'razan', 
          color: Colors.green,
        ),
        Character(
          name: 'Reem', 
          age: '3 years', 
          folderName: 'reem', 
          color: Colors.yellow,
        ),
        Character(
          name: 'Mostafa', 
          age: '6 months', 
          folderName: 'mostafa', 
          color: const Color(0xFF4B0082), // Indigo/Dark Purple
        ),
      ];
}
