class Character {
  final String name;
  final String age;
  final String folderName;

  Character({
    required this.name,
    required this.age,
    required this.folderName,
  });

  // Helper to get the correct path (defaults to png, but you can use jpg too)
  String get run1Path => 'characters/$folderName/run1.png';
  String get run2Path => 'characters/$folderName/run2.png';
  String get jumpPath => 'characters/$folderName/jump.png';
  
  // Alternative paths if you prefer JPG
  String get run1JpgPath => 'characters/$folderName/run1.jpg';
  String get run2JpgPath => 'characters/$folderName/run2.jpg';
  String get jumpJpgPath => 'characters/$folderName/jump.jpg';

  static List<Character> characters = [
    Character(name: 'Nour', age: '11 years', folderName: 'nour'),
    Character(name: 'Salama', age: '8 years', folderName: 'salama'),
    Character(name: 'Mariam', age: '7 years', folderName: 'mariam'),
    Character(name: 'Abdullah', age: '6 years', folderName: 'abdullah'),
    Character(name: 'Mohamed', age: '5 years', folderName: 'mohamed'),
    Character(name: 'Razan', age: '4 years', folderName: 'razan'),
    Character(name: 'Reem', age: '3 years', folderName: 'reem'),
    Character(name: 'Mostafa', age: '6 months', folderName: 'mostafa'),
  ];
}
