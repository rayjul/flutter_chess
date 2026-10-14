import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'features/match/data/local_game_repository.dart';
import 'features/match/presentation/match_screen.dart';

void main() {
  runApp(const TeamChessApp());
}

class TeamChessApp extends StatelessWidget {
  const TeamChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team Chess',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // Milestone 2: pass-and-play on one device.
      // Later: start at a lobby screen and pick an OnlineGameRepository.
      home: MatchScreen(repository: LocalGameRepository()),
    );
  }
}
