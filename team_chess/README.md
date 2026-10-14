# Team Chess

A chess game written in Flutter by our team. It has its own rules engine
(no chess packages), a custom board widget, and a feature-based structure.

## Getting started

```bash
cd team_chess
flutter create . --project-name team_chess   # generates android/, ios/, web/ ... (keeps our lib/ and test/)
flutter pub get
flutter test          # engine tests
flutter run
```

## Project structure

```
lib/
├── core/                      # shared: theme, routing, constants, utils
├── engine/                    # PURE DART: no Flutter, no Firebase
│   ├── board.dart             # PieceColor, PieceKind, Piece, Square
│   ├── move.dart              # Move (from, to, promotion, flag)
│   ├── move_generator.dart    # legal move generation
│   ├── rules.dart             # check, checkmate, stalemate, draw rules
│   ├── position.dart          # full game state + apply(move)
│   └── notation.dart          # FEN import/export, SAN ("Nf3")
├── features/
│   ├── auth/                  # data/ domain/ presentation/
│   ├── lobby/
│   ├── match/                 # the game screen + its state
│   │   ├── data/              #   LocalGameRepository (pass-and-play)
│   │   ├── domain/            #   GameRepository interface, GameSnapshot
│   │   └── presentation/      #   MatchScreen, BoardView
│   └── history/               # past games, replays
└── main.dart
test/
└── engine/                    # most of our tests live here
```

### Rules we follow

1. **`engine/` never imports Flutter or Firebase.** It's plain Dart, so it's
   fast to test and could later run on a server to validate online moves.
2. **`Position` is immutable.** `apply(move)` returns a new position.
3. **A game = start position + list of moves.** See `GameSnapshot`. Undo,
   replay and move history come from that list.
4. **Screens only talk to repository interfaces** (`GameRepository`), never
   to a database directly. Offline → online is a new repository, not new UI.
5. Every engine change comes with a test.

## What works now

- Board, pieces and squares; FEN parsing and formatting (tested)
- Moving pieces and promotion in `Position.apply`
- A board screen with tap-to-select, legal-move dots and undo

The board shows pieces but **no moves are possible yet**. That's because the
move generator is our first job (see below).

## Task split (find them with `grep -rn "TODO(team)"`)

| Who | Task | Files |
|---|---|---|
| A | Sliding pieces (rook, bishop, queen) + knight/king steps | `move_generator.dart` |
| B | Pawns (push, double push, captures, en passant, promotion) + castling | `move_generator.dart`, `position.dart` |
| C | `isSquareAttacked`, draw rules, SAN notation | `rules.dart`, `notation.dart` |
| D | Board UI: piece images, promotion picker, drag & drop, animations | `features/match/presentation/` |
| E | Move list, game history, then lobby + online repository | `features/history/`, `features/lobby/` |

Done when the skipped tests in `test/engine/` pass. Remove `skip:` as you
go. The perft tests in `perft_test.dart` are the final check that the move
generator is correct.

## Milestones

1. Engine complete: all perft tests pass
2. Offline pass-and-play fully playable
3. Move history (SAN), replay, chess clock
4. Online multiplayer (Firebase or Supabase) behind `GameRepository`
5. Computer opponent (minimax + alpha-beta)
