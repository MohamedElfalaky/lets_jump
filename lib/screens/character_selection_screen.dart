import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_jump/models/character.dart';
import 'package:lets_jump/screens/game_screen.dart';

class CharacterSelectionScreen extends StatefulWidget {
  const CharacterSelectionScreen({super.key});

  @override
  State<CharacterSelectionScreen> createState() =>
      _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: Stack(
          children: [
            // Background Decorative Glows
            Positioned(
              top: -100,
              right: -100,
              child: _CircularGlow(
                color: Colors.cyanAccent.withOpacity(0.1),
                size: 400,
              ),
            ),
            Positioned(
              bottom: -150,
              left: -150,
              child: _CircularGlow(
                color: Colors.blueAccent.withOpacity(0.15),
                size: 500,
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: isLandscape ? 10 : 30),
                  _PremiumHeader(isLandscape: isLandscape),
                  SizedBox(height: isLandscape ? 10 : 20),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) =>
                          setState(() => _currentPage = index),
                      itemCount: Character.characters.length,
                      itemBuilder: (context, index) {
                        final character = Character.characters[index];
                        final isSelected = _currentPage == index;
                        return _CharacterCard(
                          character: character,
                          isSelected: isSelected,
                          isLandscape: isLandscape,
                          onTap: () => _startGame(character),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: isLandscape ? 10 : 20),
                  _PageIndicator(
                    count: Character.characters.length,
                    current: _currentPage,
                  ),
                  SizedBox(height: isLandscape ? 10 : 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startGame(Character character) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(character: character)),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final Character character;
  final bool isSelected;
  final bool isLandscape;
  final VoidCallback onTap;

  const _CharacterCard({
    required this.character,
    required this.isSelected,
    required this.isLandscape,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isSelected ? 1.0 : 0.85,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        opacity: isSelected ? 1.0 : 0.6,
        duration: const Duration(milliseconds: 400),
        child: GestureDetector(
          onTap: isSelected ? onTap : null,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: isLandscape ? 5 : 15,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected
                    ? character.color.withOpacity(0.5)
                    : Colors.white10,
                width: 2,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: character.color.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  color: Colors.white.withOpacity(0.05),
                  child: isLandscape
                      ? _buildLandscapeCard()
                      : _buildPortraitCard(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitCard() {
    return Column(
      children: [
        const SizedBox(height: 30),
        Expanded(child: _buildCharacterImage()),
        const SizedBox(height: 20),
        _buildCharacterInfo(),
        const SizedBox(height: 30),
        if (isSelected) _buildPlayButton(),
        if (!isSelected) const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildLandscapeCard() {
    return Row(
      children: [
        const SizedBox(width: 30),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: _buildCharacterImage(),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCharacterInfo(),
              const SizedBox(height: 15),
              if (isSelected) _buildPlayButton(),
            ],
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildCharacterImage() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        // borderRadius: BorderRadius.circular(25),
        // border: Border.all(
        //   color: isSelected ? Colors.cyanAccent : Colors.white24,
        //   width: 3,
        // ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 15),
        ],
        shape: BoxShape.circle,
      ),
      child: FittedBox(
        fit: BoxFit.contain, // FULLY EXPAND to fill the circle
        child: Image.asset(
          'assets/images/${character.run1Path}',
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/${character.run1JpgPath}',
              fit: BoxFit.cover, // FULLY EXPAND to fill the circle
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.white24,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCharacterInfo() {
    return Column(
      children: [
        Text(
          character.name,
          style: GoogleFonts.outfit(
            fontSize: isLandscape ? 28 : 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        Text(
          character.age.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: character.color,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayButton() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 30 : 50,
        vertical: isLandscape ? 12 : 18,
      ),
      margin: EdgeInsets.only(bottom: isLandscape ? 0 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [character.color, character.color.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: character.color.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Text(
        'PLAY',
        style: GoogleFonts.outfit(
          fontSize: isLandscape ? 16 : 20,
          fontWeight: FontWeight.w900,
          color: character.color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}

class _CircularGlow extends StatelessWidget {
  final Color color;
  final double size;
  const _CircularGlow({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int count;
  final int current;
  const _PageIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: current == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: current == index ? Colors.cyanAccent : Colors.white24,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _PremiumHeader extends StatelessWidget {
  final bool isLandscape;
  const _PremiumHeader({required this.isLandscape});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'LET\'S JUMP',
          style: GoogleFonts.outfit(
            fontSize: isLandscape ? 32 : 44,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        if (!isLandscape)
          Text(
            'SELECT YOUR HERO',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white54,
              letterSpacing: 3,
            ),
          ),
      ],
    );
  }
}
