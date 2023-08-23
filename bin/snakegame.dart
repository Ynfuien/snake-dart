import 'dart:ffi';
import 'dart:math';
import 'package:ffi/ffi.dart';
import 'package:sdl2/sdl2.dart';
import 'package:win32/win32.dart' as win32;

import 'snakegame/main.dart';


// Game variables
late Border border;
late Snake snake;
late Berry berry;
late SnakeDirection direction;
late SnakeDirection newDirection;
bool gameOver = false;


void main() {
  // Hides console on startup
  win32.ShowWindow(win32.GetConsoleWindow(), win32.SW_HIDE);

  setupGame();
  setupWindow();

  return;
}

void setupGame() {
  border = Border(GRID_SIZE);
  snake = Snake(SNAKE_SIZE);
  berry = Berry(snake);
  direction = SnakeDirection.right;
  newDirection = direction;
}

void setupWindow() {
  // Initialize SDL
  if (sdlInit(SDL_INIT_EVERYTHING) != 0) {
    print(sdlGetError());
    return;
  }

  // Create window
  var window = SdlWindowEx.create(title: "Snake Dart", w: SIZE, h: SIZE, flags: SDL_WINDOW_OPENGL);
  if (window == nullptr) {
    print(sdlGetError());
    sdlQuit();
    return;
  }

  // Create renderer for window
  var renderer = window.createRenderer(-1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
  if (renderer == nullptr) {
    print(sdlGetError());
    window.destroy();
    sdlQuit();
    return;
  }

  // Initialize SDL TTF
  if (ttfInit() != 0) {
    print(ttfGetError());
    return;
  }

  // Load font
  var font = ttfOpenFont("Arial.ttf", (16 * (SCALE / 10)).toInt());
  if (font == nullptr) {
    print(ttfGetError());
    return;
  }


  // Game loop
  int lastTick = DateTime.timestamp().millisecondsSinceEpoch;
  var event = calloc<SdlEvent>();
  gameLoop : while (true) {
    while (event.poll() != 0) {
      switch (event.type) {
        case SDL_QUIT:
          break gameLoop;
        case SDL_KEYDOWN:
          keyPressed(event.key.keysym.ref.scancode);
          break;
      }
    }

    // Check if it's time for the next tick
    int now = DateTime.timestamp().millisecondsSinceEpoch;
    if (now-lastTick < TICK_TIME)  continue;
    lastTick = now;

    // Tick and render the game
    tick();
    render(renderer, font);
  }

  // Free and destroy everything
  event.callocFree();
  renderer.destroy();
  window.destroy();
  sdlQuit();
  ttfQuit();
}


void tick() {
  direction = newDirection;

  // Move snake and check if it actually moved
  if (!snake.move(direction, border))
  {
    // Game over
    gameOver = true;
    return;
  }

  // Check if snake got the berry
  if (snake.containsBerry(berry))
  {
    berry = Berry(snake);
    snake.grow();
  }
}


// Renders everything
void render(Pointer<SdlRenderer> r, Pointer<TtfFont> font) {
  // Clear
  List<int> c = GameColor.background.value;
  r.setDrawColor(c[0], c[1], c[2], 255);
  r.clear();


  // Game over screen
  if (gameOver) {
    int scale = (SCALE * 1.2).toInt();
    int score = snake.getSize() - SNAKE_SIZE;

    drawText(r, font, "Game over!", SIZE / 2, SIZE / 2 - (scale * 2.3), GameColor.gameOver);
    drawText(r, font, "Score: $score", SIZE / 2, SIZE / 2 - scale, GameColor.scoreNumber);
    drawText(r, font, "Score: ${" " * (score.toString().length * 2)}", SIZE / 2, SIZE / 2 - scale, GameColor.score);

    border.render(r, GameColor.border);
    r.present();
    return;
  }


  // Render
  snake.render(r, GameColor.snakeHead, GameColor.snakeBody);
  berry.render(r, GameColor.berry);
  border.render(r, GameColor.border);

  r.present();
}


// Draws centered text
void drawText(Pointer<SdlRenderer> r, Pointer<TtfFont> font, String text, num x, num y, GameColor color) {
  var c = color.value;
  // Render text to a surface
  var surface = font.renderUtf8Solid(text, SdlColorEx.rgbaToU32(c[0], c[1], c[2], 255));
  if (surface == nullptr) {
    print(ttfGetError());
    return;
  }

  // Create texture from the surface
  var texture = r.createTextureFromSurface(surface);
  if (texture == nullptr) {
    print(ttfGetError());
    return;
  }

  int width = surface.ref.w;
  int height = surface.ref.h;

  // Render the texture on the renderer
  var rect = Rectangle<double>(x - (width / 2), y - (height / 2), width.toDouble(), height.toDouble());
  r.copy(texture, srcrect: null, dstrect: rect);

  surface.free();
  texture.destroy();
}


// Handles pressed keys
void keyPressed(int key) {
  if (gameOver) return;

  switch (key) {
    case SDL_SCANCODE_UP:
    case SDL_SCANCODE_W:
      if (direction == SnakeDirection.down) break;
      newDirection = SnakeDirection.up;
      break;
    case SDL_SCANCODE_DOWN:
    case SDL_SCANCODE_S:
      if (direction == SnakeDirection.up) break;
      newDirection = SnakeDirection.down;
      break;
    case SDL_SCANCODE_LEFT:
    case SDL_SCANCODE_A:
      if (direction == SnakeDirection.right) break;
      newDirection = SnakeDirection.left;
      break;
    case SDL_SCANCODE_RIGHT:
    case SDL_SCANCODE_D:
      if (direction == SnakeDirection.left) break;
      newDirection = SnakeDirection.right;
      break;
  }
}