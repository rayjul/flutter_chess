import 'board.dart';
import 'move.dart';
import 'position.dart';
import 'rules.dart';

/// Generates moves for [position.sideToMove].
///
/// Two steps:
///  1. [pseudoLegalMoves]: every move pieces can physically make.
///  2. [legalMoves]: drop the ones that leave your own king in check.
class MoveGenerator {
  final Position position;

  MoveGenerator(this.position);

  List<Move> legalMoves() {
    final us = position.sideToMove;
    return pseudoLegalMoves()
        .where((m) => !Rules.isInCheck(position.apply(m), us))
        .toList();
  }

  List<Move> pseudoLegalMoves() {
    final moves = <Move>[];
    for (var i = 0; i < 64; i++) {
      final from = Square(i);
      final piece = position.pieceAt(from);
      if (piece == null || piece.color != position.sideToMove) continue;

      switch (piece.kind) {
        case PieceKind.pawn:
          moves.addAll(_pawnMoves(from, piece.color));
        case PieceKind.knight:
          moves.addAll(_stepMoves(from, knightOffsets));
        case PieceKind.bishop:
          moves.addAll(_slidingMoves(from, bishopDirections));
        case PieceKind.rook:
          moves.addAll(_slidingMoves(from, rookDirections));
        case PieceKind.queen:
          moves.addAll(
              _slidingMoves(from, [...rookDirections, ...bishopDirections]));
        case PieceKind.king:
          moves.addAll(_stepMoves(from, kingOffsets));
          moves.addAll(_castlingMoves(from, piece.color));
      }
    }
    return moves;
  }

  static const rookDirections = [(1, 0), (-1, 0), (0, 1), (0, -1)];
  static const bishopDirections = [(1, 1), (1, -1), (-1, 1), (-1, -1)];
  static const kingOffsets = [...rookDirections, ...bishopDirections];
  static const knightOffsets = [
    (1, 2), (2, 1), (2, -1), (1, -2),
    (-1, -2), (-2, -1), (-2, 1), (-1, 2),
  ];

  /// Rook, bishop, queen: slide in each direction until blocked.
  List<Move> _slidingMoves(Square from, List<(int, int)> directions) {
    // TODO(team): walk each direction square by square with Square.offset.
    // Stop at the board edge or at the first piece; include it as a
    // capture if it belongs to the opponent.
    return [];
  }

  /// Knight, king: jump to each offset if it's empty or an enemy piece.
  List<Move> _stepMoves(Square from, List<(int, int)> offsets) {
    // TODO(team)
    return [];
  }

  List<Move> _pawnMoves(Square from, PieceColor color) {
    // TODO(team): single push, double push from start rank, diagonal
    // captures, en passant (position.enPassant), promotion on last rank
    // (generate one Move per promotion piece).
    return [];
  }

  List<Move> _castlingMoves(Square from, PieceColor color) {
    // TODO(team): check castling rights, empty squares between king and
    // rook, and that the king doesn't start in, pass through, or land on
    // an attacked square (Rules.isSquareAttacked).
    return [];
  }
}
