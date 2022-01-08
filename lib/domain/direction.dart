enum Direction { left, right, up, down }

extension DirectionMethods on Direction{
  Direction oppositeDirection(){
    switch(this){
      case Direction.down: return Direction.up;
      case Direction.up: return Direction.down;
      case Direction.left: return Direction.right;
      case Direction.right: return Direction.left;
    }
  }
}
