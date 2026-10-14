import 'package:flutter/material.dart';

import '../../../engine/board.dart';
import '../../../engine/move.dart';
import '../domain/game_repository.dart';
import '../domain/game_snapshot.dart';
import 'board_view.dart';

class MatchScreen extends StatelessWidget {
  final GameRepository repository;

  const MatchScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameSnapshot>(
      stream: repository.watch(),
      initialData: repository.current,
      builder: (context, snapshot) {
        final game = snapshot.data!;
        final position = game.position;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Team Chess'),
            actions: [
              IconButton(
                tooltip: 'Undo',
                icon: const Icon(Icons.undo),
                onPressed: game.moves.isEmpty ? null : repository.undo,
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _status(game),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: Center(
                  child: BoardView(
                    position: position,
                    onMove: (Move move) => repository.submitMove(move),
                  ),
                ),
              ),
              // TODO(team): move list (features/history), clocks.
            ],
          ),
        );
      },
    );
  }

  String _status(GameSnapshot game) {
    final p = game.position;
    final side = p.sideToMove == PieceColor.white ? 'White' : 'Black';
    if (p.isCheckmate) return 'Checkmate! ${side == 'White' ? 'Black' : 'White'} wins';
    if (p.isStalemate) return 'Stalemate – draw';
    if (p.isCheck) return '$side to move – check!';
    return '$side to move';
  }
}
