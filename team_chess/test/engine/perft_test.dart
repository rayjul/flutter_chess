import 'package:flutter_test/flutter_test.dart';
import 'package:team_chess/engine/notation.dart';
import 'package:team_chess/engine/position.dart';

/// "Perft" counts every position reachable in [depth] moves.
/// Known-correct numbers catch almost any move generator bug.
/// https://www.chessprogramming.org/Perft_Results
int perft(Position position, int depth) {
  if (depth == 0) return 1;
  var nodes = 0;
  for (final move in position.legalMoves()) {
    nodes += perft(position.apply(move), depth - 1);
  }
  return nodes;
}

const _todo = 'TODO(team): enable once MoveGenerator is implemented';

void main() {
  group('perft: starting position', () {
    final start = Fen.parse(startingFen);
    test('depth 1', skip: _todo, () => expect(perft(start, 1), 20));
    test('depth 2', skip: _todo, () => expect(perft(start, 2), 400));
    test('depth 3', skip: _todo, () => expect(perft(start, 3), 8902));
  });

  group('perft: "Kiwipete" (castling, en passant, promotions)', () {
    final kiwipete = Fen.parse(
        'r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq - 0 1');
    test('depth 1', skip: _todo, () => expect(perft(kiwipete, 1), 48));
    test('depth 2', skip: _todo, () => expect(perft(kiwipete, 2), 2039));
  });

  group('perft: endgame position 3', () {
    final p = Fen.parse('8/2p5/3p4/KP5r/1R3p1k/8/4P1P1/8 w - - 0 1');
    test('depth 1', skip: _todo, () => expect(perft(p, 1), 14));
    test('depth 2', skip: _todo, () => expect(perft(p, 2), 191));
    test('depth 3', skip: _todo, () => expect(perft(p, 3), 2812));
  });
}
