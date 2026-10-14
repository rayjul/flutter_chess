import '../../../engine/move.dart';
import 'game_snapshot.dart';

/// Where a game lives. The UI only talks to this interface, so switching
/// from local pass-and-play to online play doesn't touch any screens.
abstract interface class GameRepository {
  Stream<GameSnapshot> watch();
  GameSnapshot get current;
  Future<void> submitMove(Move move);
  Future<void> undo();
}
