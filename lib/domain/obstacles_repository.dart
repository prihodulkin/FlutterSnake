import 'package:snake/domain/obstacle.dart';

abstract class ObstaclesRepository{
  Iterable<Obstacle> getBariers();
  int get bariersCount;
}