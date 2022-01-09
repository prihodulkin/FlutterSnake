import 'package:snake/domain/snake.dart';

abstract class Obstacle{
  bool hasCollision(Snake snake);
  void postCollisionCallback();
}