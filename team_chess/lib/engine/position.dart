import 'board.dart';
import 'move.dart';
import 'move_generator.dart';
import 'rules.dart';

final class CastlingRights {
  final bool whiteKingside;
  final bool whiteQueenside;
  final bool blackKingside;
  final bool blackQueenside;

  const CastlingRights({
    this.whiteKingside = false,
    this.whiteQueenside = false,
    this.blackKingside = false,
    this.blackQueenside = false,
  });

  static const all = CastlingRights(
    whiteKingside: true,
    whiteQueenside: true,
    blackKingside: true,
    blackQueenside: true,
  );

  CastlingRights copyWith({
    bool? whiteKingside,
    bool? whiteQueenside,
    bool? blackKingside,
    bool? blackQueenside,
  }) =>
      CastlingRights(
        whiteKingside: whiteKingside ?? this.whiteKingside,
        whiteQueenside: whiteQueenside ?? this.whiteQueenside,
        blackKingside: blackKingside ?? this.blackKingside,
        blackQueenside: blackQueenside ?? this.blackQueenside,
      );
}

/// The full state of a game at one moment.
///
/// Immutable: [apply] returns a NEW position, so undo/replay is just
/// keeping the list of earlier positions (or replaying the move list).
final class Position {
  /// 64 entries indexed by [Square.index]; null = empty.
  final List<Piece?> squares;
  final PieceColor sideToMove;
  final CastlingRights castling;
  final Square? enPassant;

  /// Moves since the last capture or pawn move (for the 50-move rule).
  final int halfmoveClock;
  final int fullmoveNumber;

  Position({
    required List<Piece?> squares,
    required this.sideToMove,
    this.castling = const CastlingRights(),
    this.enPassant,
    this.halfmoveClock = 0,
    this.fullmoveNumber = 1,
  })  : assert(squares.length == 64),
        squares = List.unmodifiable(squares);

  Piece? pieceAt(Square square) => squares[square.index];

  // ---- Convenience getters (logic lives in move_generator / rules) ----

  List<Move> legalMoves() => MoveGenerator(this).legalMoves();

  bool get isCheck => Rules.isInCheck(this, sideToMove);
  bool get isCheckmate => Rules.isCheckmate(this);
  bool get isStalemate => Rules.isStalemate(this);

  /// Returns the position after [move]. Assumes [move] is legal.
  Position apply(Move move) {
    final next = List<Piece?>.of(squares);
    final piece = next[move.from.index];
    if (piece == null) {
      throw ArgumentError('No piece on ${move.from.name}');
    }
    final isCapture = next[move.to.index] != null;

    next[move.to.index] =
        move.promotion != null ? Piece(piece.color, move.promotion!) : piece;
    next[move.from.index] = null;

    // TODO(team): castling – also move the rook (see MoveFlag.castle*).
    // TODO(team): en passant – remove the captured pawn behind [move.to].
    // TODO(team): update castling rights when a king or rook moves/is taken.
    // TODO(team): set [enPassant] after a double pawn push.

    final resetsClock = isCapture || piece.kind == PieceKind.pawn;
    return Position(
      squares: next,
      sideToMove: sideToMove.opposite,
      castling: castling,
      enPassant: null,
      halfmoveClock: resetsClock ? 0 : halfmoveClock + 1,
      fullmoveNumber:
          sideToMove == PieceColor.black ? fullmoveNumber + 1 : fullmoveNumber,
    );
  }
}
