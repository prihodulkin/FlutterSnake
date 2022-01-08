import 'package:snake/domain/obstacle.dart';
import 'package:snake/domain/point.dart';

class CollisionData{
  final Point collisionPoint;
  final Obstacle obstacle;
  CollisionData(this.collisionPoint, this.obstacle);
}