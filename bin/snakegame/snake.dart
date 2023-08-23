import 'dart:ffi';

import 'package:sdl2/sdl2.dart';

import 'main.dart';


class Snake {
  List<Pixel> bodyPixels = [];
  late Pixel headPixel;

  Snake(int size) {
    headPixel = Pixel((GRID_SIZE / 2 + (size / 2)).toInt(), (GRID_SIZE / 2 - 1).toInt());

    for (int i = size - 1; i > 0; i--) {
      bodyPixels.add(Pixel(headPixel.x - i, headPixel.y));
    }
  }

  void render(Pointer<SdlRenderer> r, GameColor headColor, GameColor bodyColor) {
    headPixel.render(r, headColor);

    for (Pixel p in bodyPixels) {
      p.render(r, bodyColor);
    }
  }

  bool move(SnakeDirection direction, Border border) {
    int x = headPixel.x;
    int y = headPixel.y;

    if (direction == SnakeDirection.up) y--;
    else if (direction == SnakeDirection.right) x++;
    else if (direction == SnakeDirection.down) y++;
    else if (direction == SnakeDirection.left) x--;

    Pixel newHead = Pixel(x, y);
    if (this.contains(newHead)) return false;
    if (border.contains(newHead)) return false;

    bodyPixels.add(headPixel);
    bodyPixels.removeAt(0);
    headPixel = newHead;
    return true;
  }

  void grow([int by = 1]) {
    Pixel newBody = Pixel(bodyPixels[0].x, bodyPixels[0].y);
    for (int i = 0; i < by; i++) {
      bodyPixels.insert(0, newBody);
    }
  }

  int getSize() {
    return bodyPixels.length + 1;
  }

  bool contains(Pixel pixel) {
    if (headPixel.equals(pixel)) return true;

    for (Pixel p in bodyPixels) {
      if (p.equals(pixel)) return true;
    }

    return false;
  }

  // Separate method for checking for berry,
  // because only head pixel can move onto berry position
  bool containsBerry(Berry berry) {
    return headPixel.equals(berry.position);
  }
}

enum SnakeDirection {
  up, down, left, right
}