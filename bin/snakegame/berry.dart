import 'dart:ffi';
import 'dart:math';

import 'package:sdl2/sdl2.dart';

import 'main.dart';

Random _rng = Random();

class Berry {
  late Pixel position;

  Berry(Snake snake) {
    do {
      position = Pixel(_rng.nextInt(GRID_SIZE - 2) + 1, _rng.nextInt(GRID_SIZE - 2) + 1);
    } while (snake.contains(position));
  }

  void render(Pointer<SdlRenderer> r, GameColor color) {
    position.render(r, color);
  }
}