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
  }

  void testSnakeCreation() {
    test('test snake creation', () {
      _createSnake(Point(5, 10), Direction.left);
      _checkSnakeDirection(Direction.left);
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
        expectedBody = <Point>[Point(5,10), Point(4,10),Point(3,10)];
        _checkSnakeBody(expectedBody);
      });

      test('with left direction', () {
        _createSnake(Point(5, 10), Direction.left);

        _growSnake();
        var expectedBody = <Point>[Point(5, 10), Point(6, 10)];
        _checkSnakeBody(expectedBody);

        _growSnake();
        expectedBody = <Point>[Point(5,10), Point(6,10),Point(7,10)];
        _checkSnakeBody(expectedBody);
      });

      test('with up direction', () {
        _createSnake(Point(5, 10), Direction.up);

        _growSnake();
        var expectedBody = <Point>[Point(5, 10), Point(5, 9)];
        _checkSnakeBody(expectedBody);

        _growSnake();
        expectedBody = <Point>[Point(5,10), Point(5,9),Point(5, 8)];
        _checkSnakeBody(expectedBody);
      });

      test('with down direction', () {
        _createSnake(Point(5, 10), Direction.down);

        _growSnake();
        var expectedBody = <Point>[Point(5, 10), Point(5, 11)];
        _checkSnakeBody(expectedBody);

        _growSnake();
        expectedBody = <Point>[Point(5,10), Point(5,11),Point(5,12)];
        _checkSnakeBody(expectedBody);
      });
    });
  }

  void _createSnake(Point initialPoint,
      [Direction direction = Direction.right]) {
    _snake = TestClassicSnake(initialPoint, direction);
  }

  void _moveSnake(Direction direction) {
    _snake.direction = direction;
    _snake.move();
  }

  void _growSnake() {
    _snake.grow();
  }

  void _checkSnakeDirection(Direction direction) {
    expect(_snake.direction, Direction.left,
        reason: 'direction should be ${direction.toString()}');
  }

  void _checkSnakeBody(Iterable<Point> expectedBody) {
    assert(_equality.equals(_snake.getBody(), expectedBody),
        'body should be ${expectedBody.toString()}');
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
