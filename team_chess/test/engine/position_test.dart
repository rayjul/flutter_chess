import 'package:flutter_test/flutter_test.dart';
import 'package:team_chess/engine/board.dart';
import 'package:team_chess/engine/move.dart';
import 'package:team_chess/engine/notation.dart';

Move m(String from, String to, {MoveFlag flag = MoveFlag.normal}) =>
    Move(Square.parse(from), Square.parse(to), flag: flag);

void main() {
  test('apply moves a piece and switches side', () {
    final p = Fen.parse(startingFen).apply(m('g1', 'f3'));
    expect(p.pieceAt(Square.parse('g1')), isNull);
    expect(p.pieceAt(Square.parse('f3')),
        const Piece(PieceColor.white, PieceKind.knight));
    expect(p.sideToMove, PieceColor.black);
    expect(p.halfmoveClock, 1);
  });

  test('apply does not change the original position', () {
    final start = Fen.parse(startingFen);
    start.apply(m('e2', 'e4', flag: MoveFlag.doublePawnPush));
    expect(Fen.format(start), startingFen);
  });

  test('promotion replaces the pawn', () {
    final p = Fen.parse('8/4P3/8/8/8/8/8/k6K w - - 0 1').apply(Move(
        Square.parse('e7'), Square.parse('e8'),
        promotion: PieceKind.queen));
    expect(p.pieceAt(Square.parse('e8')),
        const Piece(PieceColor.white, PieceKind.queen));
  });

  test('double pawn push sets en passant square',
      skip: 'TODO(team): Position.apply', () {
    final p = Fen.parse(startingFen)
        .apply(m('e2', 'e4', flag: MoveFlag.doublePawnPush));
    expect(p.enPassant?.name, 'e3');
  });

  test('castling also moves the rook', skip: 'TODO(team): Position.apply', () {
    final p = Fen.parse('r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1')
        .apply(m('e1', 'g1', flag: MoveFlag.castleKingside));
    expect(p.pieceAt(Square.parse('f1'))?.kind, PieceKind.rook);
    expect(p.pieceAt(Square.parse('h1')), isNull);
    expect(p.castling.whiteKingside, isFalse);
  });
}
