import '../../../engine/move.dart';
import '../../../engine/notation.dart';
import '../../../engine/position.dart';

/// A game is a start position plus the list of moves played.
/// The current position is derived from those, which gives us
/// undo, replay and move history for free.
final class GameSnapshot {
  final Position start;
  final List<Move> moves;

  /// positions[0] == start, positions[i] == after moves[i - 1].
  final List<Position> positions;

  GameSnapshot._(this.start, this.moves, this.positions);

  factory GameSnapshot.initial([String fen = startingFen]) {
    final start = Fen.parse(fen);
    return GameSnapshot._(start, const [], [start]);
  }

  Position get position => positions.last;

  GameSnapshot play(Move move) => GameSnapshot._(
        start,
        List.unmodifiable([...moves, move]),
        List.unmodifiable([...positions, position.apply(move)]),
      );

  GameSnapshot undo() => moves.isEmpty
      ? this
      : GameSnapshot._(
          start,
          List.unmodifiable(moves.sublist(0, moves.length - 1)),
          List.unmodifiable(positions.sublist(0, positions.length - 1)),
        );
}
