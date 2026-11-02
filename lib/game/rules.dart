/// Slide rules. An arrow leaves only when every cell of its shape has a clear
/// lane in that direction. Removing an arrow never closes another lane.
library;

import 'model.dart';

abstract final class GameRules {
  static const hearts = 3;
  static const hints = 3;
}

abstract final class Rules {
  static Set<Cell> occupied(PuzzleLevel level, Set<int> removed) {
    final cells = <Cell>{};
    for (final arrow in level.arrows) {
      if (removed.contains(arrow.id)) continue;
      cells.addAll(arrow.cells);
    }
    return cells;
  }

  /// True when some other arrow sits in the lane this shape would slide through.
  static bool directionBlocked(
    PuzzleLevel level,
    ArrowPiece arrow,
    Direction dir,
    Set<Cell> others,
  ) {
    for (final cell in arrow.cells) {
      var x = cell.x + dir.dx;
      var y = cell.y + dir.dy;
      while (x >= 0 && y >= 0 && x < level.cols && y < level.rows) {
        if (others.contains(Cell(x, y))) return true;
        x += dir.dx;
        y += dir.dy;
      }
    }
    return false;
  }

  static List<Direction> openExits(PuzzleLevel level, ArrowPiece arrow, Set<int> removed) {
    final others = occupied(level, removed)..removeAll(arrow.cells);
    final exits = <Direction>[];
    if (!directionBlocked(level, arrow, arrow.dir, others)) exits.add(arrow.dir);
    final alt = arrow.alt;
    if (alt != null && !directionBlocked(level, arrow, alt, others)) exits.add(alt);
    return exits;
  }

  static int? bestHint(PuzzleLevel level, Set<int> removed) {
    final alive = level.arrows.where((a) => !removed.contains(a.id)).toList();
    final open = alive.where((a) => openExits(level, a, removed).isNotEmpty).toList();
    if (open.isEmpty) return null;

    var best = open.first;
    var bestScore = -1;
    for (final arrow in open) {
      final next = {...removed, arrow.id};
      var score = 0;
      for (final other in alive) {
        if (other.id == arrow.id) continue;
        final wasOpen = openExits(level, other, removed).isNotEmpty;
        final nowOpen = openExits(level, other, next).isNotEmpty;
        if (!wasOpen && nowOpen) score++;
      }
      if (score > bestScore || (score == bestScore && arrow.id < best.id)) {
        best = arrow;
        bestScore = score;
      }
    }
    return best.id;
  }

  static bool solvable(PuzzleLevel level) {
    final removed = <int>{};
    while (removed.length < level.arrows.length) {
      ArrowPiece? next;
      for (final arrow in level.arrows) {
        if (removed.contains(arrow.id)) continue;
        if (openExits(level, arrow, removed).isNotEmpty) {
          next = arrow;
          break;
        }
      }
      if (next == null) return false;
      removed.add(next.id);
    }
    return true;
  }

  /// Null when the level is a solvable puzzle with a first move and a block.
  static String? validate(PuzzleLevel level) {
    if (level.cols < 2 || level.rows < 2) return 'grid';
    if (level.arrows.length < 2) return 'arrows';
    final seen = <Cell>{};
    for (final arrow in level.arrows) {
      if (arrow.cells.isEmpty) return 'empty ${arrow.id}';
      for (final cell in arrow.cells) {
        final inside =
            cell.x >= 0 && cell.y >= 0 && cell.x < level.cols && cell.y < level.rows;
        if (!inside) return 'outside ${arrow.id} $cell';
        if (!seen.add(cell)) return 'overlap ${arrow.id} $cell';
      }
      for (var i = 0; i < arrow.cells.length - 1; i++) {
        final a = arrow.cells[i];
        final b = arrow.cells[i + 1];
        final step = (b.x - a.x).abs() + (b.y - a.y).abs();
        if (step != 1) return 'gap ${arrow.id}';
      }
      if (arrow.cells.length >= 2) {
        final neck = _step(arrow.cells[arrow.cells.length - 2], arrow.head);
        if (neck != arrow.dir) return 'head ${arrow.id}';
        final alt = arrow.alt;
        if (alt != null && alt != _step(arrow.tail, arrow.cells[1]).opposite) {
          return 'alt ${arrow.id}';
        }
      } else if (arrow.alt != null && arrow.alt != arrow.dir.opposite) {
        return 'alt ${arrow.id}';
      }
    }
    const removed = <int>{};
    final anyOpen = level.arrows.any((a) => openExits(level, a, removed).isNotEmpty);
    final anyBlocked = level.arrows.any((a) => openExits(level, a, removed).isEmpty);
    if (!anyOpen) return 'no opening';
    if (!anyBlocked) return 'no block';
    if (!solvable(level)) return 'unsolvable';
    return null;
  }

  static Direction _step(Cell from, Cell to) {
    if (to.x > from.x) return Direction.right;
    if (to.x < from.x) return Direction.left;
    if (to.y > from.y) return Direction.down;
    return Direction.up;
  }

  /// Steps until every cell of [arrow] has left the board.
  static int travel(PuzzleLevel level, ArrowPiece arrow, Direction dir) {
    var steps = 1;
    for (final cell in arrow.cells) {
      final n = switch (dir) {
        Direction.right => level.cols - cell.x,
        Direction.left => cell.x + 1,
        Direction.down => level.rows - cell.y,
        Direction.up => cell.y + 1,
      };
      if (n > steps) steps = n;
    }
    return steps;
  }
}

sealed class TapResult {
  const TapResult();
}

class TapIgnored extends TapResult {
  const TapIgnored();
}

class TapBumped extends TapResult {
  const TapBumped(this.dir);
  final Direction dir;
}

class TapCleared extends TapResult {
  const TapCleared(this.dir);
  final Direction dir;
}

class GameSession {
  GameSession(this.level)
    : hearts = GameRules.hearts,
      hints = GameRules.hints;

  final PuzzleLevel level;
  final Set<int> removed = {};
  int hearts;
  int hints;

  bool get won => removed.length == level.arrows.length;
  bool get lost => hearts <= 0;

  TapResult tap(int id) {
    if (won || lost) return const TapIgnored();
    ArrowPiece? arrow;
    for (final piece in level.arrows) {
      if (piece.id == id) arrow = piece;
    }
    if (arrow == null || removed.contains(id)) return const TapIgnored();
    final exits = Rules.openExits(level, arrow, removed);
    if (exits.isEmpty) {
      hearts -= 1;
      return TapBumped(arrow.dir);
    }
    removed.add(id);
    return TapCleared(exits.first);
  }

  int? useHint() {
    if (hints <= 0 || won || lost) return null;
    final id = Rules.bestHint(level, removed);
    if (id == null) return null;
    hints -= 1;
    return id;
  }
}
