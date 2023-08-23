export 'pixel.dart';
export 'border.dart';
export 'snake.dart';
export 'berry.dart';

const GRID_SIZE = 32;
const SNAKE_SIZE = 5;
const SCALE = 20;
const SIZE = GRID_SIZE * SCALE + GRID_SIZE - 1;
const TICK_TIME = 100;

enum GameColor {
  background([36, 36, 36]),
  snakeHead([4, 89, 156]),
  snakeBody([45, 183, 246]),
  berry([255, 85, 85]),
  border([85, 85, 85]),
  gameOver([255, 85, 85]),
  score([255, 255, 85]),
  scoreNumber([255, 170, 0]);

  final List<int> value;
  const GameColor(this.value);
}