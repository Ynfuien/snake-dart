import 'dart:ffi';

import 'package:sdl2/sdl2.dart';

import 'pixel.dart';
import 'main.dart';

class Border {
  List<Pixel> borderPixels = [];

  Border(int size) {
    for (int i = 0; i <= size - 1; i++) {
      // Border in width
      borderPixels.add(Pixel(i, 0));
      borderPixels.add(Pixel(i, size - 1));

      // Border in height
      if (i == 0 || i == size - 1) continue;
      borderPixels.add(Pixel(0, i));
      borderPixels.add(Pixel(size - 1, i));
    }
  }

  void render(Pointer<SdlRenderer> r, GameColor color) {
    for (Pixel p in borderPixels) {
      p.render(r, color);
    }
  }

  bool contains(Pixel pixel) {
    for (Pixel p in borderPixels) {
      if (p.equals(pixel)) return true;
    }

    return false;
  }
}