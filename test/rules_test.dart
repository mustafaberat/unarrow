import 'package:unarrow/game/levels.dart';
import 'package:unarrow/game/model.dart';
import 'package:unarrow/game/rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every level is a real puzzle', () {
    expect(Levels.all.length, greaterThanOrEqualTo(12));
    final issues = <String>[];
    for (var i = 0; i < Levels.all.length; i++) {
      final issue = Rules.validate(Levels.all[i]);
      if (issue != null) issues.add('level ${i + 1}: $issue');
    }
    expect(issues, isEmpty);
  });

  test('a legal hint clears level 1 with all hearts', () {
    final session = GameSession(Levels.all[0]);
    var guard = 0;
    while (!session.won && guard++ < 30) {
      final id = Rules.bestHint(session.level, session.removed);
      expect(id, isNotNull);
      expect(session.tap(id!), isA<TapCleared>());
    }
    expect(session.won, isTrue);
    expect(session.hearts, GameRules.hearts);
  });

  test('a blocked tap costs a heart and stays on the board', () {
    final session = GameSession(Levels.all[0]);
    final blocked = Levels.all[0].arrows.firstWhere(
      (arrow) => Rules.openExits(Levels.all[0], arrow, {}).isEmpty,
    );
    expect(session.tap(blocked.id), isA<TapBumped>());
    expect(session.hearts, GameRules.hearts - 1);
    expect(session.removed, isEmpty);
  });

  test('the whole shape slides, so a side cell can block a bend', () {
    final level = PuzzleLevel(
      cols: 5,
      rows: 4,
      arrows: [
        const ArrowPiece(
          id: 0,
          dir: Direction.right,
          cells: [Cell(2, 1), Cell(2, 2), Cell(3, 2)],
        ),
        const ArrowPiece(id: 1, dir: Direction.up, cells: [Cell(3, 1)]),
      ],
    );
    expect(Rules.openExits(level, level.arrows[0], {}), isEmpty);
    expect(Rules.openExits(level, level.arrows[1], {}), [Direction.up]);
    final session = GameSession(level);
    expect(session.tap(1), isA<TapCleared>());
    expect(session.tap(0), isA<TapCleared>());
    expect(session.won, isTrue);
  });

  test('two arrows facing each other cannot be cleared', () {
    final level = PuzzleLevel(
      cols: 3,
      rows: 1,
      arrows: [
        const ArrowPiece(id: 0, dir: Direction.right, cells: [Cell(0, 0)]),
        const ArrowPiece(id: 1, dir: Direction.left, cells: [Cell(2, 0)]),
      ],
    );
    expect(Rules.solvable(level), isFalse);
  });

  test('a two-way arrow leaves by the open end', () {
    final level = PuzzleLevel(
      cols: 5,
      rows: 1,
      arrows: [
        const ArrowPiece(
          id: 0,
          dir: Direction.right,
          alt: Direction.left,
          cells: [Cell(1, 0), Cell(2, 0), Cell(3, 0)],
        ),
        const ArrowPiece(id: 1, dir: Direction.up, cells: [Cell(4, 0)]),
      ],
    );
    final session = GameSession(level);
    final result = session.tap(0);
    expect(result, isA<TapCleared>());
    expect((result as TapCleared).dir, Direction.left);
  });
}
