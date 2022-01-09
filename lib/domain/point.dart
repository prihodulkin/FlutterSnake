import 'direction.dart';

class Point {
  final int x;
  final int y;
  Point(this.x, this.y);

  @override
  bool operator ==(var other) {
    if (other is Point) {
      return x == other.x && y == other.y;
    }
    return false;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() {
    return "(x: $x y: $y)";
  }

  Point moveAlongDirection(Direction direction) {
    switch (direction) {
      case Direction.left:
        return Point(x - 1, y);
      case Direction.right:
        return Point(x + 1, y);
      case Direction.up:
        return Point(x, y + 1);
      case Direction.down:
        return Point(x, y - 1);
    }
  }
}
