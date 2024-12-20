import java.util.*;
WindowManager windowManager;
Vector2 windowSize = new Vector2(200,200);

void settings() {
  size((int)windowSize.x, (int)windowSize.y);
}

void setup() {
  windowManager = new WindowManager();
  windowManager.callReady();
}

void draw() {
  windowManager.run();
}
