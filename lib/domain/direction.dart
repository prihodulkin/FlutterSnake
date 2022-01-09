enum Direction { left, right, up, down }

extension DirectionMethods on Direction {
  Direction oppositeDirection() {
    switch (this) {
      case Direction.down:
        return Direction.up;
      case Direction.up:
        return Direction.down;
      case Direction.left:
        return Direction.right;
      case Direction.right:
        return Direction.left;
    }
  }

  Direction turnLeft() {
    switch (this) {
      case Direction.down:
        return Direction.right;
      case Direction.left:
        return Direction.down;
      case Direction.up:
        return Direction.left;
      case Direction.right:
        return Direction.up;
    }
  }

  Direction turnRight() {
    switch (this) {
      case Direction.down:
        return Direction.left;
      case Direction.left:
        return Direction.up;
      case Direction.up:
        return Direction.right;
      case Direction.right:
        return Direction.down;
    }
  }
}
