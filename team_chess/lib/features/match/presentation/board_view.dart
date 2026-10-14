import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../engine/board.dart';
import '../../../engine/move.dart';
import '../../../engine/position.dart';

/// Tap a piece to select it, then tap a highlighted square to move.
class BoardView extends StatefulWidget {
  final Position position;
  final ValueChanged<Move> onMove;
  final bool flipped;

  const BoardView({
    super.key,
    required this.position,
    required this.onMove,
    this.flipped = false,
  });

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  Square? _selected;

  @override
  void didUpdateWidget(BoardView old) {
    super.didUpdateWidget(old);
    if (old.position != widget.position) _selected = null;
  }

  List<Move> get _targets => _selected == null
      ? const []
      : widget.position
          .legalMoves()
          .where((m) => m.from == _selected)
          .toList();

  void _onTap(Square square) {
    final moves = _targets.where((m) => m.to == square).toList();
    if (moves.isNotEmpty) {
      // TODO(team): ask which piece when there are several promotion moves.
      widget.onMove(moves.firstWhere(
        (m) => m.promotion == null || m.promotion == PieceKind.queen,
        orElse: () => moves.first,
      ));
      setState(() => _selected = null);
      return;
    }
    final piece = widget.position.pieceAt(square);
    setState(() {
      _selected =
          piece != null && piece.color == widget.position.sideToMove
              ? square
              : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final targets = _targets.map((m) => m.to).toSet();
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemCount: 64,
        itemBuilder: (context, i) {
          // Grid index 0 is the top-left cell; for white that's a8.
          final row = i ~/ 8, col = i % 8;
          final square = widget.flipped
              ? Square.at(7 - col, row)
              : Square.at(col, 7 - row);
          final isLight = (square.file + square.rank).isOdd;
          final piece = widget.position.pieceAt(square);

          return GestureDetector(
            onTap: () => _onTap(square),
            child: Container(
              color: square == _selected
                  ? BoardColors.selected
                  : isLight
                      ? BoardColors.light
                      : BoardColors.dark,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (targets.contains(square))
                    const FractionallySizedBox(
                      widthFactor: 0.3,
                      heightFactor: 0.3,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: BoardColors.target,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  if (piece != null)
                    FittedBox(
                      child: Text(
                        _glyph(piece),
                        style: const TextStyle(fontSize: 48, color: Colors.black),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // TODO(team): replace Unicode glyphs with your own piece images/SVGs.
  static String _glyph(Piece p) => switch ((p.color, p.kind)) {
        (PieceColor.white, PieceKind.king) => '♔',
        (PieceColor.white, PieceKind.queen) => '♕',
        (PieceColor.white, PieceKind.rook) => '♖',
        (PieceColor.white, PieceKind.bishop) => '♗',
        (PieceColor.white, PieceKind.knight) => '♘',
        (PieceColor.white, PieceKind.pawn) => '♙',
        (PieceColor.black, PieceKind.king) => '♚',
        (PieceColor.black, PieceKind.queen) => '♛',
        (PieceColor.black, PieceKind.rook) => '♜',
        (PieceColor.black, PieceKind.bishop) => '♝',
        (PieceColor.black, PieceKind.knight) => '♞',
        (PieceColor.black, PieceKind.pawn) => '♟',
      };
}
