import 'package:snake/domain/point.dart';

abstract class Obstacle{
  ///[point] is a some object representaion in model coordinates
  bool hasCollision(Point point);
  void postCollisionCallback();
}