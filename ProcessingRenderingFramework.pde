import java.util.*;
WindowManager windowManager;
Vector2 windowSize = new Vector2(200,200);

void settings() {
  size((int)windowSize.x, (int)windowSize.y);
}

void setup() {
  windowManager = new WindowManager();
  
  Button testBttn = new Button(windowManager.mainWindow, new Vector2(0), 0.0, new Vector2(100, 50), "Hello world");
  windowManager.callReady();
}

void draw() {
  windowManager.run();
}
