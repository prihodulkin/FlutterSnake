import 'package:flutter_test/flutter_test.dart';
import 'package:snake/domain/entities/point.dart';
import 'package:snake/domain/entities/direction.dart';
import 'package:snake/domain/entities/snake.dart';
import 'package:collection/collection.dart';

import 'entites/test_classic_snake.dart';
import 'helpers/test_snake_mixin.dart';

void main() {
  var tester = ClassicSnakeTester();
  tester.runAllTests();
}

class ClassicSnakeTester with TestSnakeMixin{
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
      createSnake(Point(5, 10), Direction.left);
      _checkSnakeHeadDirection(Direction.left);
      var expectedBody = <Point>[Point(5, 10)];
      _checkSnakeBody(expectedBody);
    });
  }

  void testSingleDirectionSnakeGrowing() {
    group('test single direction snake growing', () {
      test('with right direction', () {
        createSnake(Point(5, 10), Direction.right);

        growSnake();
        var expectedBody = <Point>[Point(5, 10), Point(4, 10)];
        _checkSnakeBody(expectedBody);

        growSnake();
        expectedBody = <Point>[Point(5, 10), Point(4, 10), Point(3, 10)];
        _checkSnakeBody(expectedBody);
      });

      test('with left direction', () {
        createSnake(Point(5, 10), Direction.left);

        growSnake();
        var expectedBody = <Point>[Point(5, 10), Point(6, 10)];
        _checkSnakeBody(expectedBody);

        growSnake();
        expectedBody = <Point>[Point(5, 10), Point(6, 10), Point(7, 10)];
        _checkSnakeBody(expectedBody);
      });

      test('with up direction', () {
        createSnake(Point(5, 10), Direction.up);

        growSnake();
        var expectedBody = <Point>[Point(5, 10), Point(5, 9)];
        _checkSnakeBody(expectedBody);

        growSnake();
        expectedBody = <Point>[Point(5, 10), Point(5, 9), Point(5, 8)];
        _checkSnakeBody(expectedBody);
      });

      test('with down direction', () {
        createSnake(Point(5, 10), Direction.down);

        growSnake();
        var expectedBody = <Point>[Point(5, 10), Point(5, 11)];
        _checkSnakeBody(expectedBody);

        growSnake();
        expectedBody = <Point>[Point(5, 10), Point(5, 11), Point(5, 12)];
        _checkSnakeBody(expectedBody);
      });
    });
  }

  void testSingleSegmentSnakeMovement() {
    test('test single segment snake movement', () {
      createSnake(Point(5, 10), Direction.right);

      moveSnakeStraight();
      var expectedBody = <Point>[Point(6, 10)];
      _checkSnakeBody(expectedBody);

      moveSnakeLeft(2);
      expectedBody = <Point>[Point(6, 12)];
      _checkSnakeBody(expectedBody);

      moveSnakeRight(3);
      expectedBody = <Point>[Point(9, 12)];
      _checkSnakeBody(expectedBody);
    });
  }

  void testSnakeMovementWithTurns() {
    test('test snake movement with turns', () {
      createSnake(Point(5, 10), Direction.right);
      growSnake(3);
      var expectedBody = <Point>[
        Point(5, 10),
        Point(4, 10),
        Point(3, 10),
        Point(2, 10)
      ];
      _checkSnakeBody(expectedBody);

      moveSnakeLeft();
      expectedBody = <Point>[
        Point(5, 11),
        Point(5, 10),
        Point(4, 10),
        Point(3, 10),
      ];
      _checkSnakeBody(expectedBody);

      moveSnakeStraight();
      expectedBody = <Point>[
        Point(5, 12),
        Point(5, 11),
        Point(5, 10),
        Point(4, 10),
      ];
      _checkSnakeBody(expectedBody);

      moveSnakeRight(2);
      expectedBody = <Point>[
        Point(7, 12),
        Point(6, 12),
        Point(5, 12),
        Point(5, 11),
      ];
      _checkSnakeBody(expectedBody);
    });
  }

  
  void testSnakeCollision() {
    group('test snake collision', () {
      test('with itself', () {
        createSnake(Point(6, 8), Direction.right);
        growSnake(4);
        moveSnakeRight();
        _checkNoSnakeCollision();
        moveSnakeRight();
        _checkNoSnakeCollision();
        moveSnakeRight();
        _checkSnakeCollision();
      });

      test('with other snake', () {
        createSnake(Point(6, 8), Direction.right);
        growSnake(4);

        var obstacleSnake = TestClassicSnake(Point(8, 7), Direction.down);
        obstacleSnake.grow();

        moveSnakeStraight();
        _checkNoSnakeCollision(obstacleSnake);
        
        moveSnakeStraight();
        _checkSnakeCollision(obstacleSnake);
      });
    });
  }

  void _checkSnakeHeadDirection(Direction direction) {
    expect(snake.headDirection, Direction.left,
        reason:
            'head direction should be ${direction.toString()} but was ${snake.headDirection}');
  }

  void _checkSnakeBody(Iterable<Point> expectedBody) {
    assert(_equality.equals(snake.getBody(), expectedBody),
        'body should be ${expectedBody.toString()} but was ${snake.getBody()}');
  }

  void _checkSnakeCollision([Snake? obstacleSnake]) {
    obstacleSnake ??= snake;
    var hasCollision = obstacleSnake.hasCollision(snake);
    expect(hasCollision, true,
        reason:
            'collision should be detected. Snake: $snake, obstacle snake: $obstacleSnake');
  }

  void _checkNoSnakeCollision([Snake? obstacleSnake]) {
    obstacleSnake ??= snake;
    var hasCollision = obstacleSnake.hasCollision(snake);
    expect(hasCollision, false,
        reason:
            'collision shouldn\'t be detected. Snake: $snake, obstacle snake: $obstacleSnake');
  }
}


