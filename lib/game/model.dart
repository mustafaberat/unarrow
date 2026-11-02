/// Grid arrows. The head is the last cell. The body keeps its shape and
/// slides in [dir] (and [alt], when the arrow has two heads).
library;

enum Direction {
  up,
  right,
  down,
  left;

  int get dx => switch (this) {
    Direction.right => 1,
    Direction.left => -1,
    _ => 0,
  };

  int get dy => switch (this) {
    Direction.down => 1,
    Direction.up => -1,
    _ => 0,
  };

  Direction get opposite => switch (this) {
    Direction.up => Direction.down,
    Direction.down => Direction.up,
    Direction.left => Direction.right,
    Direction.right => Direction.left,
  };
}

class Cell {
  const Cell(this.x, this.y);

  final int x;
  final int y;

  @override
  bool operator ==(Object other) => other is Cell && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '($x,$y)';
}

class ArrowPiece {
  const ArrowPiece({
    required this.id,
    required this.cells,
    required this.dir,
    this.alt,
  });

  final int id;

  /// Tail → head.
  final List<Cell> cells;
  final Direction dir;

  /// Second head at the tail, when the arrow can leave either way.
  final Direction? alt;

  Cell get head => cells.last;
  Cell get tail => cells.first;

  @override
  String toString() => 'Arrow#$id $dir${alt == null ? '' : '/$alt'} $cells';
}

class PuzzleLevel {
  PuzzleLevel({
    required this.cols,
    required this.rows,
    required List<ArrowPiece> arrows,
  }) : arrows = [
         for (var i = 0; i < arrows.length; i++)
           ArrowPiece(
             id: i,
             cells: List<Cell>.unmodifiable(arrows[i].cells),
             dir: arrows[i].dir,
             alt: arrows[i].alt,
           ),
       ];

  final int cols;
  final int rows;
  final List<ArrowPiece> arrows;
}
