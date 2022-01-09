import 'package:flutter_test/flutter_test.dart';
import 'package:snake/domain/point.dart';
import 'package:snake/domain/direction.dart';
import 'package:snake/domain/snake.dart';
import 'package:collection/collection.dart';

void main() {
  var tester = ClassicSnakeTester();
  tester.runAllTests();
}

class ClassicSnakeTester {
  late ClassicSnake _snake;
  final DeepCollectionEquality _equality = const DeepCollectionEquality();

  void runAllTests() {
    testSnakeCreation();
    testSingleDirectionSnakeGrowing();
    testSingleSegmentSnakeMovement();
    testSnakeMovementWithTurns();
    testSnakeCollision();
  }

  void testSnakeCreation() {
    test('test snake creation', () {
      _createSnake(Point(5, 10), Direction.left);
      _checkSnakeHeadDirection(Direction.left);
      var expectedBody = <Point>[Point(5, 10)];
      _checkSnakeBody(expectedBody);
    });
  }

  void testSingleDirectionSnakeGrowing() {
    group('test single direction snake growing', () {
      test('with right direction', () {
        _createSnake(Point(5, 10), Direction.right);

        _growSnake();
        var expectedBody = <Point>[Point(5, 10), Point(4, 10)];
        _checkSnakeBody(expectedBody);

        _growSnake();
        expectedBody = <Point>[Point(5, 10), Point(4, 10), Point(3, 10)];
        _checkSnakeBody(expectedBody);
      });

      test('with left direction', () {
        _createSnake(Point(5, 10), Direction.left);

        _growSnake();
        var expectedBody = <Point>[Point(5, 10), Point(6, 10)];
        _checkSnakeBody(expectedBody);

        _growSnake();
        expectedBody = <Point>[Point(5, 10), Point(6, 10), Point(7, 10)];
        _checkSnakeBody(expectedBody);
      });

      test('with up direction', () {
        _createSnake(Point(5, 10), Direction.up);

        _growSnake();
        var expectedBody = <Point>[Point(5, 10), Point(5, 9)];
        _checkSnakeBody(expectedBody);

        _growSnake();
        expectedBody = <Point>[Point(5, 10), Point(5, 9), Point(5, 8)];
        _checkSnakeBody(expectedBody);
      });

      test('with down direction', () {
        _createSnake(Point(5, 10), Direction.down);

        _growSnake();
        var expectedBody = <Point>[Point(5, 10), Point(5, 11)];
        _checkSnakeBody(expectedBody);

        _growSnake();
        expectedBody = <Point>[Point(5, 10), Point(5, 11), Point(5, 12)];
        _checkSnakeBody(expectedBody);
      });
    });
  }

  void testSingleSegmentSnakeMovement() {
    test('test single segment snake movement', () {
      _createSnake(Point(5, 10), Direction.right);

      _moveSnakeStraight();
      var expectedBody = <Point>[Point(6, 10)];
      _checkSnakeBody(expectedBody);

      _moveSnakeLeft(2);
      expectedBody = <Point>[Point(6, 12)];
      _checkSnakeBody(expectedBody);

      _moveSnakeRight(3);
      expectedBody = <Point>[Point(9, 12)];
      _checkSnakeBody(expectedBody);
    });
  }

  void testSnakeMovementWithTurns() {
    test('test snake movement with turns', () {
      _createSnake(Point(5, 10), Direction.right);
      _growSnake(3);
      var expectedBody = <Point>[
        Point(5, 10),
        Point(4, 10),
        Point(3, 10),
        Point(2, 10)
      ];
      _checkSnakeBody(expectedBody);

      _moveSnakeLeft();
      expectedBody = <Point>[
        Point(5, 11),
        Point(5, 10),
        Point(4, 10),
        Point(3, 10),
      ];
      _checkSnakeBody(expectedBody);

      _moveSnakeStraight();
      expectedBody = <Point>[
        Point(5, 12),
        Point(5, 11),
        Point(5, 10),
        Point(4, 10),
      ];
      _checkSnakeBody(expectedBody);

      _moveSnakeRight(2);
      expectedBody = <Point>[
        Point(7, 12),
        Point(6, 12),
        Point(5, 12),
        Point(5, 11),
      ];
      _checkSnakeBody(expectedBody);
    });
  }

  void _createSnake(Point initialPoint,
      [Direction direction = Direction.right]) {
    _snake = TestClassicSnake(initialPoint, direction);
  }

  void _moveSnakeStraight([int movementsCount = 1]) {
    assert(movementsCount >= 1, 'count should be natural');
    for (int i = 0; i < movementsCount; i++) {
      _snake.moveStraight();
    }
  }

  void _moveSnakeLeft([int movementsCount = 1]) {
    assert(movementsCount >= 1, 'count should be natural');
    _snake.moveLeft();
    for (int i = 1; i < movementsCount; i++) {
      _snake.moveStraight();
    }
  }

  void _moveSnakeRight([int movementsCount = 1]) {
    assert(movementsCount >= 1, 'count should be natural');
    _snake.moveRight();
    for (int i = 1; i < movementsCount; i++) {
      _snake.moveStraight();
    }
  }

  void testSnakeCollision() {
    group('test snake collision', () {
      test('with itself', () {
        _createSnake(Point(6, 8), Direction.right);
        _growSnake(4);
        _moveSnakeRight();
        _checkNoSnakeCollision();
        _moveSnakeRight();
        _checkNoSnakeCollision();
        _moveSnakeRight();
        _checkSnakeCollision();
      });

      test('with other snake', () {
        _createSnake(Point(6, 8), Direction.right);
        _growSnake(4);

        var obstacleSnake = TestClassicSnake(Point(8, 7), Direction.down);
        obstacleSnake.grow();

        _moveSnakeStraight();
        _checkNoSnakeCollision(obstacleSnake);
        
        _moveSnakeStraight();
        _checkSnakeCollision(obstacleSnake);
      });
    });
  }

  void _growSnake([int growsCount = 1]) {
    assert(growsCount >= 1, 'count should be natural');
    for (int i = 0; i < growsCount; i++) {
      _snake.grow();
    }
  }

  void _checkSnakeHeadDirection(Direction direction) {
    expect(_snake.headDirection, Direction.left,
        reason:
            'head direction should be ${direction.toString()} but was ${_snake.headDirection}');
  }

  void _checkSnakeBody(Iterable<Point> expectedBody) {
    assert(_equality.equals(_snake.getBody(), expectedBody),
        'body should be ${expectedBody.toString()} but was ${_snake.getBody()}');
  }

  void _checkSnakeCollision([Snake? obstacleSnake]) {
    obstacleSnake ??= _snake;
    var hasCollision = obstacleSnake.hasCollision(_snake);
    expect(hasCollision, true,
        reason:
            'collision should be detected. Snake: $_snake, obstacle snake: $obstacleSnake');
  }

  void _checkNoSnakeCollision([Snake? obstacleSnake]) {
    obstacleSnake ??= _snake;
    var hasCollision = obstacleSnake.hasCollision(_snake);
    expect(hasCollision, false,
        reason:
            'collision shouldn\'t be detected. Snake: $_snake, obstacle snake: $obstacleSnake');
  }
}

class TestClassicSnake extends ClassicSnake {
  TestClassicSnake(Point initialPoint, Direction direction)
      : super(initialPoint, direction);

  @override
  void postCollisionCallback() {
    throw UnimplementedError("test class");
  }
}
