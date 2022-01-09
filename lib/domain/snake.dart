import 'package:snake/domain/obstacle.dart';
import 'package:snake/domain/point.dart';
import 'package:snake/domain/points_moving_mixin.dart';
import 'direction.dart';

///represents snake behaviour in model coordinates
abstract class Snake implements Obstacle {
  void moveStraight();
  void moveLeft();
  void moveRight();
  void grow();

  ///contains coordinates of snake's segments from head to tail
  Iterable<Point> getBody();

  Direction get headDirection;
  Point get head;
  Point get tail;
  int get length;

  @override
  String toString() {
    var stringBuffer = StringBuffer('{ Snake: ');
    for(var segment in getBody()){
      stringBuffer.write(segment);
      stringBuffer.write('<-');
    }
    stringBuffer.write(' }');
    return stringBuffer.toString();
  }
}

///The snake which grows by one segment in the tail and moves only straight
abstract class ClassicSnake extends Snake with PointsMovingMixin {
  final List<Point> _body;
  Direction _direction;

  ClassicSnake(Point initialPoint, Direction direction)
      : _body = <Point>[initialPoint],
        _direction = direction;

  ///In case of the classical snake growing means add one segment in the tail
  @override
  void grow() {
    Direction lastSegmentDirection;
    if (length > 1) {
      var prevToTail = _body[_body.length - 2];
      lastSegmentDirection = getStraightMovingDirection(tail, prevToTail);
    } else {
      lastSegmentDirection = headDirection;
    }
    _body.add(tail.moveAlongDirection(lastSegmentDirection.oppositeDirection()));
  }

  @override
  void moveStraight() {
    var prevComponent = tail;
    for (int i = _body.length - 2; i >= 0; i--) {
      var nextComponent = _body[i];
      var movingDirection =
          getStraightMovingDirection(prevComponent, nextComponent);
      _body[i + 1] = prevComponent.moveAlongDirection(movingDirection);
      prevComponent = nextComponent;
    }
    _body[0] = head.moveAlongDirection(headDirection);
  }

  @override
  void moveLeft() {
    _direction = headDirection.turnLeft();
    moveStraight();
  }

  @override
  void moveRight() {
    _direction = headDirection.turnRight();
    moveStraight();
  }

  @override
  Iterable<Point> getBody() sync* {
    for (var segment in _body) {
      yield segment;
    }
  }

  @override
  Direction get headDirection => _direction;

  @override
  Point get head => _body.first;

  @override
  Point get tail => _body.last;

  @override
  int get length => _body.length;

  @override
  bool hasCollision(Snake snake) {
    int startIndex = snake == this ? 1 : 0;
    var snakeHead = snake.head;
    for (int i = startIndex; i < _body.length; i++) {
      var segment = _body[i];
      if (segment == snakeHead) {
        return true;
      }
    }

    return false;
  }
}
