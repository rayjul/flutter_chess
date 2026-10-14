import 'board.dart';
import 'move_generator.dart';
import 'position.dart';

/// Game-ending and check logic.
abstract final class Rules {
  /// True if any piece of [by] attacks [square].
  static bool isSquareAttacked(Position position, Square square, PieceColor by) {
    // TODO(team): look outward from [square]: knight jumps, sliding lines
    // (rook/queen, bishop/queen), pawn diagonals, adjacent king.
    return false;
  }

  static bool isInCheck(Position position, PieceColor color) {
    for (var i = 0; i < 64; i++) {
      final piece = position.squares[i];
      if (piece == PieceKind.king.of(color)) {
        return isSquareAttacked(position, Square(i), color.opposite);
      }
    }
    return false; // No king (e.g. test positions).
  }

  static bool isCheckmate(Position position) =>
      isInCheck(position, position.sideToMove) && _hasNoMoves(position);

  static bool isStalemate(Position position) =>
      !isInCheck(position, position.sideToMove) && _hasNoMoves(position);

  static bool isFiftyMoveDraw(Position position) =>
      position.halfmoveClock >= 100;

  // TODO(team): insufficient material (K v K, K+B v K, K+N v K).
  // TODO(team): threefold repetition (needs the game's position history).

  static bool _hasNoMoves(Position position) =>
      MoveGenerator(position).legalMoves().isEmpty;
}

extension on PieceKind {
  Piece of(PieceColor color) => Piece(color, this);
}
