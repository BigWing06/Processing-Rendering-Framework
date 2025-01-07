WindowManager root; // Constant access point for the WindowManager
PApplet mainPApp = this; // PApplet for the origin window


public class WindowManager {
  
  
  List<Character>keyList=new ArrayList<>(); // List of currently pressed keys
  ArrayList<ChildWindow> childWindows = new ArrayList<ChildWindow>(); // All of our extended PApplets (excluding the main window)
  EventManager eventManager; // The controller for all events
  Window mainWindow; // The original window created by Processing
  
  
  WindowManager() { // Sets all parameters for the window;
    root = this;
    this.mainWindow = new Window(mainPApp);
    this.setupDebug(); // Checks the debug list for any special debug actions to be run
    this.mainWindow.fill = color(255);
    this.eventManager = new EventManager();
  }
  
  void callReady() { // Runs the process function once to parent all children; Then runs the ready function of all children of all windows.
    mainWindow.tick();
    mainWindow.ready();
    for (ChildWindow window : this.childWindows) {
      window.window.tick();
      window.window.ready();
    }
  }

  void run() { // Evaluates vital events, runs process and draw
    this.eventManager.evaluateVitalEvents();
    mainWindow.tick();
    mainWindow.draw();
  }
  
  void setupDebug() { // Sets special actions for debug
    if (debugOptions.contains(Debug.hierarchyWindow)) {
      new HierarchyWindow();
    }
  }
  
  Window createWindow(Vector2 initialSize_, Vector2 initialPos_, String name_) { // Creates a new ChildWindow class instance
    ChildWindow newWindow = createChildWindow(initialSize_, initialPos_, name_);
    return newWindow.window;
  }
  
  ChildWindow createChildWindow(Vector2 initialSize_, Vector2 initialPos_, String name_) { // creates a new ChildWindow instance and adds it to the childWindows list
    ChildWindow newWindow = new ChildWindow(initialSize_, initialPos_, name_);
    this.childWindows.add(newWindow);
    return newWindow;
  }
}


public class ChildWindow extends PApplet {
  Vector2 initialSize; // The size the window should appear as
  Vector2 initialPos; // The position the window should appear at
  String name; // The title of the window
  Window window; // The window (Node) instance that will be the parent Node for everything within the window
  
  public ChildWindow(Vector2 initialSize_, Vector2 initialPos_, String name_) { // The constructor, sets the variables
    super();
    root.childWindows.add(this);
    initialSize = initialSize_;
    initialPos = initialPos_;
    name = name_;
    createSubWindow(); // Creates a Window (Node) instance
    PApplet.runSketch(new String[]{this.getClass().getName()}, this); // Runs the code or something I HAVE NO IDEA HOW THIS WORKS
    super.surface.setSize((int)this.initialSize.x, (int)this.initialSize.y);
    super.surface.setLocation((int)this.initialPos.x, (int)this.initialPos.y);
  }
  
  void createSubWindow() { // Creates the Window (Node) instance that will be the parent Node
    this.window = new Window(this);
    this.window.name = this.name;
  }
  
  
  public void setup() { // Sets the window's name, is run on creation
    surface.setTitle(this.name);
  }
  
  @Override
    public void draw() { // Draws and processes the Window (Node) for this ChildWindow; Runs once a loop
    this.window.tick();
    this.window.draw();
  }
  
  public void windowResized() { //UMMM delete this maybe
  }
  
}

void keyPressed() {
  root.eventManager.runEventType(new EventData("KeyPressed").setKey(key)); // Runs all KeyPressed events on the key that was pressed
}

void keyReleased() {
  root.eventManager.runEventType(new EventData("KeyReleased").setKey(key)); // Runs the KeyReleased Event with the key released
}

void mousePressed() {
  root.eventManager.runEventType(new EventData("MousePressed").setMouseBtn(mouseButton).setMousePos(new Vector2(mouseX, mouseY))); // Runs the MousePressed event with the mouse position and mouse button
}

void mouseReleased() {
  root.eventManager.runEventType(new EventData("MouseReleased").setMouseBtn(mouseButton).setMousePos(new Vector2(mouseX, mouseY))); // Runs the MouseReleased event with the mouse position and mouse button
}  


// DEBUG VARIABLES AND FUNCTIONS BELOW //

public enum Debug { // The debug feature options
  adoptionLog, positionDots, collisionLog, hierarchyWindow
};

List<Debug> debugOptions = Arrays.asList(new Debug[]{Debug.hierarchyWindow, Debug.collisionLog}); // The features currently in use

void log(Object message, Debug option) { // Print the debug message if the option in active
  if (debugOptions.contains(option)) {
    print("\n[DEBUG] " + message);
  }
}

void tempLog(Object message) { // Print the message with tempLog formating 
  print("\n<<<<[TEMP DEBUG]>>>>> " + message);
}
