import 'dart:ffi';
import 'dart:math';

import 'package:sdl2/sdl2.dart';

import 'main.dart';

class Pixel {
  int x = 0;
  int y = 0;

  Pixel(int x, int y) {
    this.x = x > GRID_SIZE ? GRID_SIZE : x;
    this.y = y > GRID_SIZE ? GRID_SIZE : y;
  }

  void render(Pointer<SdlRenderer> r, GameColor color) {
    List<int> c = color.value;
    r.setDrawColor(c[0], c[1], c[2], 255);
    r.fillRect(Rectangle((x * SCALE + x).toDouble(), (y * SCALE + y).toDouble(), SCALE.toDouble(), SCALE.toDouble()));
  }

  bool equals(Pixel pixel) {
    return pixel.x == x && pixel.y == y;
  }
}