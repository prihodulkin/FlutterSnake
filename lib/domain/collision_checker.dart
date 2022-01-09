import 'package:snake/domain/collision_data.dart';
import 'package:snake/domain/obstacles_repository.dart';
import 'package:snake/domain/snake.dart';

class CollisionChecker {
  ///returns [CollisionData] if there is self-coollision or 
  ///collision with obstacle
  ///or null if there are no collisions
  static CollisionData? checkSnakeCollisionWithObstacleOrItself(
      Snake snake, ObstaclesRepository obstaclesRepository) {
    if (checkSnakeCollisionWithObstacle(snake, obstaclesRepository) == null) {
      return checkSnakeSelfCollision(snake);
    }
  }

  ///returns null if there are no collisions
  static CollisionData? checkSnakeCollisionWithObstacle(
      Snake snake, ObstaclesRepository obstaclesRepository) {
    for (var obstacle in obstaclesRepository.getBariers()) {
      if (obstacle.hasCollision(snake)) {
        return CollisionData(snake.head, obstacle);
      }
    }
  }

  ///returns null if there are no collisions
  static CollisionData? checkSnakeSelfCollision(Snake snake) {
    if (snake.hasCollision(snake)) {
      return CollisionData(snake.head, snake);
    }
  }
}
