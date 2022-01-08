import 'package:snake/domain/obstacle.dart';
import 'package:snake/domain/point.dart';
import 'package:snake/domain/points_moving_mixin.dart';
import 'direction.dart';

///represents snake behaviour in model coordinates
abstract class Snake implements Obstacle {
  Direction direction;
  void move();
  void grow();

  ///contains coordinates of snake's segments from head to tail
  Iterable<Point> getBody();
  Point get head;
  Point get tail;
  int get length;
  Snake(Point initialPoint, this.direction);
}

///The snake which grows by one segment in the tail and moves only straight
abstract class ClassicSnake extends Snake with PointsMovingMixin {
  final List<Point> _body;

  ClassicSnake(Point initialPoint, Direction direction)
      : _body = <Point>[initialPoint],
        super(initialPoint, direction);

  ///In case of the classical snake growing means add one segment in the tail
  @override
  void grow() {
    Direction lastSegmentDirection;
    if (length > 1) {
      var prevToTail = _body[_body.length - 2];
      lastSegmentDirection = getStraightMovingDirection(tail, prevToTail);
    } else {
      lastSegmentDirection = direction;
    }
    _body.add(tail.moveStraight(lastSegmentDirection.oppositeDirection()));
  }

  ///One point moving along ```direction```
  @override
  void move() {
    var prevComponent = tail;
    for (int i = _body.length - 2; i >= 0; i--) {
      var nextComponent = _body[i];
      var movingDirection =
          getStraightMovingDirection(prevComponent, nextComponent);
      _body[i + 1] = prevComponent.moveStraight(movingDirection);
      prevComponent = nextComponent;
    }
    _body[0] = head.moveStraight(direction);
  }

  @override
  Iterable<Point> getBody() sync* {
    for (var segment in _body) {
      yield segment;
    }
  }

  @override
  Point get head => _body.first;

  @override
  Point get tail => _body.last;

  @override
  int get length => _body.length;

  @override
  bool hasCollision(Point point) {
    for (var segment in _body) {
      if (point == segment) return true;
    }
    return false;
  }
}
