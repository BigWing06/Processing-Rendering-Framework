public class HierarchyWindow extends ChildWindow {
  Text2D display; // The text that will be shown on screen
  
  HierarchyWindow() { // The constructor; Sets up the window. All of the design is preset here.
    super(new Vector2(600, 600), new Vector2(0, 0), "HierarchyWindow");
    this.window.fill = color(255);
    display = new Text2D(this.window, new Vector2(0, 0), "", 10.0, 0.0);
    display.setParentWindow(this.window);
    fill(0);
    rect(0, 0, 50, 50);
    display.fill = color(0);
    this.window.printChildren();
  }
  
  @Override // Draws the hierarchy to the window
    void draw() {
    super.draw();
    try {
      String windowText = root.mainWindow.printChildren();
      for (ChildWindow window : root.childWindows) {
        windowText += "\n";
        windowText += window.window.getChildrenHierarchyText();
      }
      this.display.text = windowText;
      this.display.fontSize = super.height / (windowText.split("\n").length)/(displayHeight/524);
      //this.display.fontSize = 15;
    }
    catch(Exception e) {
    }
  }
  
  @Override
    void setup() { // Runs when the PApplet generates and makes the window resizable
    super.setup();
    super.surface.setResizable(true);
  }
}
