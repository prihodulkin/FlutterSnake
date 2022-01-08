import 'package:snake/domain/collision_data.dart';
import 'package:snake/domain/obstacles_repository.dart';
import 'package:snake/domain/snake.dart';

class CollisionChecker {
  ///returns [CollisionData] if there is self-coollision or 
  ///collision with obstacle
  ///or null if there are no collisions
  static CollisionData? checkAnySnakeCollision(
      Snake snake, ObstaclesRepository obstaclesRepository) {
    if (checkSnakeCollisionWithObstacle(snake, obstaclesRepository) == null) {
      return checkSnakeSelfCollision(snake);
    }
  }

  ///returns null if there are no collisions
  static CollisionData? checkSnakeCollisionWithObstacle(
      Snake snake, ObstaclesRepository obstaclesRepository) {
    var snakeHead = snake.head;
    for (var obstacle in obstaclesRepository.getBariers()) {
      if (obstacle.hasCollision(snakeHead)) {
        return CollisionData(snakeHead, obstacle);
      }
    }
  }

  ///returns null if there are no collisions
  static CollisionData? checkSnakeSelfCollision(Snake snake) {
    var snakeHead = snake.head;
    if (snake.hasCollision(snakeHead)) {
      return CollisionData(snakeHead, snake);
    }
  }
}
