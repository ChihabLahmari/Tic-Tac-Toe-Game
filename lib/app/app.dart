import 'package:flutter/material.dart';
import 'package:xo_game/presentation/game_screen/view/game.dart';
import 'package:xo_game/presentation/new_game_screen/new_game_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewGameScreen(),
    );
  }
}
