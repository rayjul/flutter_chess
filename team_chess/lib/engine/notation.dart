import 'board.dart';
import 'move.dart';
import 'position.dart';

const startingFen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

/// Converts between [Position] and FEN strings.
/// https://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation
abstract final class Fen {
  static Position parse(String fen) {
    final parts = fen.trim().split(RegExp(r'\s+'));
    if (parts.length != 6) throw FormatException('FEN needs 6 fields: $fen');

    final squares = List<Piece?>.filled(64, null);
    final ranks = parts[0].split('/');
    if (ranks.length != 8) throw FormatException('FEN needs 8 ranks: $fen');
    for (var r = 0; r < 8; r++) {
      final rank = 7 - r; // FEN starts from rank 8.
      var file = 0;
      for (final char in ranks[r].split('')) {
        final empty = int.tryParse(char);
        if (empty != null) {
          file += empty;
        } else {
          final piece = Piece.fromSymbol(char);
          if (piece == null || file > 7) {
            throw FormatException('Bad FEN rank "${ranks[r]}"');
          }
          squares[Square.at(file, rank).index] = piece;
          file++;
        }
      }
      if (file != 8) throw FormatException('Bad FEN rank "${ranks[r]}"');
    }

    final side = switch (parts[1]) {
      'w' => PieceColor.white,
      'b' => PieceColor.black,
      _ => throw FormatException('Bad side to move: ${parts[1]}'),
    };

    final c = parts[2];
    final castling = CastlingRights(
      whiteKingside: c.contains('K'),
      whiteQueenside: c.contains('Q'),
      blackKingside: c.contains('k'),
      blackQueenside: c.contains('q'),
    );

    return Position(
      squares: squares,
      sideToMove: side,
      castling: castling,
      enPassant: parts[3] == '-' ? null : Square.parse(parts[3]),
      halfmoveClock: int.parse(parts[4]),
      fullmoveNumber: int.parse(parts[5]),
    );
  }

  static String format(Position position) {
    final rows = <String>[];
    for (var rank = 7; rank >= 0; rank--) {
      final row = StringBuffer();
      var empty = 0;
      for (var file = 0; file < 8; file++) {
        final piece = position.pieceAt(Square.at(file, rank));
        if (piece == null) {
          empty++;
        } else {
          if (empty > 0) row.write(empty);
          empty = 0;
          row.write(piece.symbol);
        }
      }
      if (empty > 0) row.write(empty);
      rows.add(row.toString());
    }

    final c = position.castling;
    final castling = [
      if (c.whiteKingside) 'K',
      if (c.whiteQueenside) 'Q',
      if (c.blackKingside) 'k',
      if (c.blackQueenside) 'q',
    ].join();

    return [
      rows.join('/'),
      position.sideToMove == PieceColor.white ? 'w' : 'b',
      castling.isEmpty ? '-' : castling,
      position.enPassant?.name ?? '-',
      position.halfmoveClock,
      position.fullmoveNumber,
    ].join(' ');
  }
}

/// Standard Algebraic Notation, e.g. "Nf3", "exd5", "O-O", "e8=Q+".
abstract final class San {
  static String format(Position before, Move move) {
    // TODO(team): piece letter, disambiguation (Nbd2), 'x' for captures,
    // '=Q' for promotion, '+' / '#' suffix, 'O-O' / 'O-O-O'.
    return move.uci;
  }
}
