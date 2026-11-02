import 'model.dart';

/// Hand-built boards. Each one has a clear first move and a blocked arrow,
/// and can be cleared by taking open arrows in any order.
abstract final class Levels {
  static final List<PuzzleLevel> all = [
    _level(5, 5, [
      _line(2, 0, Direction.up, 1),
      _line(2, 1, Direction.up, 1),
      _line(2, 2, Direction.up, 1),
      _line(2, 3, Direction.up, 1),
      _line(0, 2, Direction.left, 1),
      _line(4, 3, Direction.right, 1),
    ]),
    _level(5, 6, [
      _line(1, 0, Direction.up, 1),
      _line(1, 1, Direction.up, 1),
      _line(1, 2, Direction.up, 1),
      _line(3, 5, Direction.down, 1),
      _line(3, 4, Direction.down, 1),
      _line(3, 3, Direction.down, 1),
    ]),
    _level(6, 5, [
      _line(2, 2, Direction.right, 2),
      _line(4, 2, Direction.up, 1),
      _line(4, 3, Direction.up, 2),
      _line(0, 2, Direction.left, 1),
      _line(1, 4, Direction.down, 1),
    ]),
    _level(7, 5, [
      _line(4, 1, Direction.right, 3),
      _line(6, 1, Direction.up, 1),
      _line(0, 1, Direction.left, 1),
      _line(3, 3, Direction.down, 2),
      _line(6, 4, Direction.right, 1),
      _line(1, 4, Direction.left, 2),
    ]),
    _level(6, 6, [
      _path([
        [1, 1],
        [1, 2],
        [1, 3],
        [2, 3],
        [3, 3],
      ], Direction.right),
      _line(5, 3, Direction.up, 1),
      _line(0, 3, Direction.right, 1),
      _line(3, 5, Direction.up, 1),
      _line(2, 0, Direction.down, 1),
    ]),
    _level(5, 5, [
      _path([
        [2, 1],
        [2, 2],
        [3, 2],
      ], Direction.right),
      _line(3, 1, Direction.up, 1),
      _line(0, 2, Direction.left, 1),
      _line(1, 4, Direction.down, 1),
      _line(4, 4, Direction.right, 1),
    ]),
    _level(8, 6, [
      _path([
        [0, 2],
        [1, 2],
        [2, 2],
        [2, 3],
        [2, 4],
        [3, 4],
        [4, 4],
        [5, 4],
      ], Direction.right),
      _line(7, 4, Direction.up, 1),
      _line(7, 0, Direction.up, 1),
      _line(2, 0, Direction.down, 1),
      _line(4, 5, Direction.up, 1),
      _line(0, 5, Direction.left, 1),
    ]),
    _level(6, 5, [
      _line(3, 2, Direction.right, 3, alt: Direction.left),
      _line(5, 2, Direction.up, 1),
      _line(0, 2, Direction.down, 1),
      _line(2, 0, Direction.up, 1),
      _line(2, 4, Direction.down, 1),
    ]),
    _level(7, 7, [
      _path([
        [1, 1],
        [2, 1],
        [3, 1],
        [3, 2],
        [3, 3],
      ], Direction.down),
      _line(3, 5, Direction.down, 1),
      _path([
        [5, 2],
        [5, 3],
        [5, 4],
        [4, 4],
      ], Direction.left),
      _line(1, 4, Direction.left, 1),
      _line(6, 1, Direction.right, 1),
      _line(0, 6, Direction.down, 1),
    ]),
    _level(6, 6, [
      _line(2, 2, Direction.down, 2),
      _line(2, 4, Direction.down, 1),
      _line(1, 2, Direction.right, 1),
      _line(4, 1, Direction.up, 2),
      _line(0, 5, Direction.left, 1),
      _line(5, 5, Direction.right, 1),
    ]),
    _level(7, 7, [
      _line(3, 3, Direction.down, 3),
      _line(3, 5, Direction.down, 1),
      _path([
        [0, 5],
        [1, 5],
        [2, 5],
      ], Direction.right),
      _line(1, 2, Direction.left, 2),
      _line(6, 2, Direction.right, 1),
      _line(5, 0, Direction.up, 1),
      _line(6, 6, Direction.right, 1),
    ]),
    _level(8, 7, [
      _line(4, 3, Direction.left, 3, alt: Direction.right),
      _line(0, 3, Direction.up, 1),
      _line(7, 4, Direction.down, 2),
      _path([
        [2, 1],
        [3, 1],
        [4, 1],
        [4, 2],
      ], Direction.down),
      _line(4, 5, Direction.down, 1),
      _line(7, 1, Direction.right, 1),
      _line(1, 6, Direction.left, 2),
    ]),
    _level(8, 8, [
      _path([
        [1, 1],
        [1, 2],
        [1, 3],
        [2, 3],
        [3, 3],
        [3, 4],
        [3, 5],
      ], Direction.down),
      _line(3, 7, Direction.down, 1),
      _line(5, 3, Direction.right, 2),
      _line(0, 3, Direction.left, 1),
      _path([
        [6, 5],
        [6, 6],
        [5, 6],
        [4, 6],
      ], Direction.left),
      _line(2, 6, Direction.left, 1),
      _line(7, 0, Direction.up, 1),
    ]),
    _level(8, 8, [
      _line(4, 1, Direction.right, 4),
      _line(6, 1, Direction.up, 1),
      _line(6, 5, Direction.down, 3),
      _line(6, 7, Direction.down, 1),
      _path([
        [0, 4],
        [1, 4],
        [2, 4],
        [2, 5],
      ], Direction.down),
      _line(2, 7, Direction.down, 1),
      _line(4, 4, Direction.left, 2),
      _line(0, 0, Direction.up, 1),
      _line(7, 7, Direction.right, 1),
    ]),
    _level(9, 8, [
      _path([
        [1, 2],
        [2, 2],
        [3, 2],
        [4, 2],
        [4, 3],
        [4, 4],
        [5, 4],
        [6, 4],
      ], Direction.right),
      _line(8, 4, Direction.right, 1),
      _line(4, 6, Direction.down, 2),
      _line(6, 1, Direction.up, 2),
      _line(2, 7, Direction.left, 3),
      _line(0, 7, Direction.down, 1),
      _line(8, 1, Direction.up, 1),
      _path([
        [7, 6],
        [7, 7],
        [8, 7],
      ], Direction.right),
    ]),
    _level(9, 9, [
      _line(4, 4, Direction.up, 3, alt: Direction.down),
      _line(4, 0, Direction.up, 1),
      _line(4, 8, Direction.down, 1),
      _path([
        [1, 4],
        [2, 4],
        [3, 4],
      ], Direction.right),
      _path([
        [6, 2],
        [7, 2],
        [7, 3],
        [7, 4],
      ], Direction.down),
      _line(7, 6, Direction.down, 1),
      _line(1, 1, Direction.left, 2),
      _line(8, 8, Direction.right, 1),
      _line(0, 7, Direction.left, 1),
    ]),
  ];

  static PuzzleLevel _level(int cols, int rows, List<ArrowPiece> arrows) {
    return PuzzleLevel(cols: cols, rows: rows, arrows: arrows);
  }

  static ArrowPiece _line(int x, int y, Direction dir, int length, {Direction? alt}) {
    return ArrowPiece(
      id: 0,
      dir: dir,
      alt: alt,
      cells: [
        for (var i = length - 1; i >= 0; i--) Cell(x - dir.dx * i, y - dir.dy * i),
      ],
    );
  }

  static ArrowPiece _path(List<List<int>> points, Direction dir, {Direction? alt}) {
    return ArrowPiece(
      id: 0,
      dir: dir,
      alt: alt,
      cells: [for (final point in points) Cell(point[0], point[1])],
    );
  }
}
