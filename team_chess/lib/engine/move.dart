import 'board.dart';

/// What kind of move this is. The move generator sets it so that
/// [Position.apply] knows about side effects (rook jump, pawn removal...).
enum MoveFlag {
  normal,
  capture,
  doublePawnPush,
  enPassant,
  castleKingside,
  castleQueenside,
}

final class Move {
  final Square from;
  final Square to;
  final MoveFlag flag;

  /// Set only when a pawn reaches the last rank.
  final PieceKind? promotion;

  const Move(
    this.from,
    this.to, {
    this.flag = MoveFlag.normal,
    this.promotion,
  });

  /// Long algebraic form, e.g. 'e2e4' or 'e7e8q'. Useful for debugging/tests.
  String get uci {
    const promo = {
      PieceKind.knight: 'n',
      PieceKind.bishop: 'b',
      PieceKind.rook: 'r',
      PieceKind.queen: 'q',
    };
    return '${from.name}${to.name}${promotion == null ? '' : promo[promotion]}';
  }

  @override
  bool operator ==(Object other) =>
      other is Move &&
      other.from == from &&
      other.to == to &&
      other.promotion == promotion;

  @override
  int get hashCode => Object.hash(from, to, promotion);

  @override
  String toString() => uci;
}
