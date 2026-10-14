import 'package:flutter_test/flutter_test.dart';
import 'package:team_chess/engine/board.dart';
import 'package:team_chess/engine/notation.dart';

void main() {
  group('Square', () {
    test('parses and names squares', () {
      expect(Square.parse('a1').index, 0);
      expect(Square.parse('h8').index, 63);
      expect(Square.parse('e4').name, 'e4');
      expect(Square.parse('e4').file, 4);
      expect(Square.parse('e4').rank, 3);
    });

    test('offset returns null off the board', () {
      expect(Square.parse('h1').offset(1, 0), isNull);
      expect(Square.parse('e4').offset(1, 1)?.name, 'f5');
    });
  });

  group('Fen', () {
    test('parses the starting position', () {
      final p = Fen.parse(startingFen);
      expect(p.pieceAt(Square.parse('e1')),
          const Piece(PieceColor.white, PieceKind.king));
      expect(p.pieceAt(Square.parse('d8')),
          const Piece(PieceColor.black, PieceKind.queen));
      expect(p.pieceAt(Square.parse('e4')), isNull);
      expect(p.sideToMove, PieceColor.white);
      expect(p.castling.blackQueenside, isTrue);
    });

    test('round-trips', () {
      const fens = [
        startingFen,
        'r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq - 0 1',
        '8/2p5/3p4/KP5r/1R3p1k/8/4P1P1/8 w - - 0 1',
        'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2',
      ];
      for (final fen in fens) {
        expect(Fen.format(Fen.parse(fen)), fen);
      }
    });

    test('rejects garbage', () {
      expect(() => Fen.parse('not a fen'), throwsFormatException);
      expect(() => Fen.parse('8/8/8/8/8/8/8/9 w - - 0 1'), throwsFormatException);
    });
  });
}
