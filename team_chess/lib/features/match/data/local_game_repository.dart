import 'dart:async';

import '../../../engine/move.dart';
import '../domain/game_repository.dart';
import '../domain/game_snapshot.dart';

/// Pass-and-play: the game lives in memory on this device.
class LocalGameRepository implements GameRepository {
  final _controller = StreamController<GameSnapshot>.broadcast();
  GameSnapshot _current;

  LocalGameRepository([GameSnapshot? initial])
      : _current = initial ?? GameSnapshot.initial();

  @override
  GameSnapshot get current => _current;

  @override
  Stream<GameSnapshot> watch() => _controller.stream;

  @override
  Future<void> submitMove(Move move) async {
    if (!_current.position.legalMoves().contains(move)) {
      throw ArgumentError('Illegal move: $move');
    }
    _emit(_current.play(move));
  }

  @override
  Future<void> undo() async => _emit(_current.undo());

  void _emit(GameSnapshot snapshot) {
    _current = snapshot;
    _controller.add(snapshot);
  }

  void dispose() => _controller.close();
}
