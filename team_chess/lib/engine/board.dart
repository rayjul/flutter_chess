/// Basic building blocks: colors, pieces and squares.
///
/// This file is pure Dart. Never import Flutter or Firebase in `engine/`.
library;

enum PieceColor {
  white,
  black;

  PieceColor get opposite => this == white ? black : white;
}

enum PieceKind { pawn, knight, bishop, rook, queen, king }

final class Piece {
  final PieceColor color;
  final PieceKind kind;

  const Piece(this.color, this.kind);

  /// FEN letter: uppercase for white, lowercase for black (e.g. 'N', 'q').
  String get symbol {
    const letters = {
      PieceKind.pawn: 'p',
      PieceKind.knight: 'n',
      PieceKind.bishop: 'b',
      PieceKind.rook: 'r',
      PieceKind.queen: 'q',
      PieceKind.king: 'k',
    };
    final letter = letters[kind]!;
    return color == PieceColor.white ? letter.toUpperCase() : letter;
  }

  static Piece? fromSymbol(String symbol) {
    const kinds = {
      'p': PieceKind.pawn,
      'n': PieceKind.knight,
      'b': PieceKind.bishop,
      'r': PieceKind.rook,
      'q': PieceKind.queen,
      'k': PieceKind.king,
    };
    final kind = kinds[symbol.toLowerCase()];
    if (kind == null) return null;
    final color =
        symbol == symbol.toUpperCase() ? PieceColor.white : PieceColor.black;
    return Piece(color, kind);
  }

  @override
  bool operator ==(Object other) =>
      other is Piece && other.color == color && other.kind == kind;

  @override
  int get hashCode => Object.hash(color, kind);

  @override
  String toString() => symbol;
}

/// A square on the board, 0..63. a1 = 0, b1 = 1, ..., h8 = 63.
extension type const Square(int index) {
  factory Square.at(int file, int rank) => Square(rank * 8 + file);

  /// Parses algebraic names such as 'e4'.
  factory Square.parse(String name) {
    if (name.length != 2) throw FormatException('Bad square: $name');
    final file = name.codeUnitAt(0) - 'a'.codeUnitAt(0);
    final rank = name.codeUnitAt(1) - '1'.codeUnitAt(0);
    if (file < 0 || file > 7 || rank < 0 || rank > 7) {
      throw FormatException('Bad square: $name');
    }
    return Square.at(file, rank);
  }

  /// Column 0..7 (a..h).
  int get file => index % 8;

  /// Row 0..7 (1..8).
  int get rank => index ~/ 8;

  String get name => '${String.fromCharCode(97 + file)}${rank + 1}';

  /// Returns the square shifted by [df] files and [dr] ranks,
  /// or null if that falls off the board. Handy for move generation.
  Square? offset(int df, int dr) {
    final f = file + df, r = rank + dr;
    if (f < 0 || f > 7 || r < 0 || r > 7) return null;
    return Square.at(f, r);
  }
}
