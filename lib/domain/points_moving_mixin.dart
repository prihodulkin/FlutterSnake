import 'package:snake/domain/point.dart';
import 'direction.dart';

mixin PointsMovingMixin {
  Direction getStraightMovingDirection(Point from, Point to) {
    if (from.x == to.x) {
      if (to.y < from.y) {
        return Direction.down;
      } else {
        return Direction.up;
      }
    } else {
      if (to.x < from.x) {
        return Direction.left;
      } else {
        return Direction.right;
      }
    }
  }
}
