public class Node {
  Window parentWindow; // The window the Node is parented to 
  String name = "Untitled"; // The name of the Node to be displayed
  Integer id;
  ArrayList<Node> children = new ArrayList<Node>();
  Boolean processing = true; // If the Node runs its process function on process
  Boolean mouseOver = false; // If the mouse if hovering over the Node
  
  
  
  
  Size sizeMode = Size.basic; // The way the Node is sized, either inhieriting or to the values the values that get set
  
  Node parent = null;
  List<Float> collisionLayers = Arrays.asList(new Float[]{0.0});
  HashMap<Float, ArrayList<Node>> layerMap = new HashMap<Float, ArrayList<Node>>();
  HashMap<String, Method> vitalEventDefaults = new HashMap<String, Method>();
  ArrayList<Integer> killList = new ArrayList<Integer>();
  ArrayList<Event> activeEvents = new ArrayList<Event>();
  private Vector2 pos;
  Float layer;
  Boolean visible = true;
  color strokeColor = color(0, 0, 0);
  color fill = color (0, 0, 0, 0);
  float strokeWeight = 0.0;
  private Vector2 size;
  Vector2 originPos = new Vector2(-1, -1);
  Vector2 attachmentPos = new Vector2(-1, -1);
  Node() {

    this.createVitalEventDefaultHashmap();
    this.parentWindow = ((Window)this);
  };
  Node(Node parent_, Vector2 pos_, Float layer_, Vector2 size_) {
    this.createVitalEventDefaultHashmap();
    this.parentWindow = root.mainWindow; // THIS NEEDS FIXED
    this.setupNode(parent_, pos_, layer_, size_);
  }
  void createVitalEventDefaultHashmap() {

    this.vitalEventDefaults.put("MouseHover", (Method)(this::onMouseHover));
    this.vitalEventDefaults.put("MouseLeave", (Method)(this::onMouseLeave));
  }
  void onMouseHover(){
    this.mouseOver = true;
  }
  void onMouseLeave(){
   this.mouseOver = false; 
  }
  void onAdoption() {
  }
  void setupNode(Node parent_, Vector2 pos_, Float layer, Vector2 size) {
    this.parent(parent_);
    this.pos = pos_;
    this.layer = layer;
    this.size = size;
  }
  void setParentWindow(Window parentWindow_) {
    this.parentWindow = parentWindow_;
  }
  void createEvent(Event event_) {
    this.activeEvents.add(event_);
    root.eventManager.createEvent(event_);
  }
  void deleteAllEvents() {
    for (Event event : this.activeEvents) {
      root.eventManager.removeEvent(event);
    }
    this.activeEvents = new ArrayList<Event>();
  }
  void deleteEvent(Event event_) {
    if (activeEvents.contains(event_)) {
      this.activeEvents.remove(event_);
      root.eventManager.removeEvent(event_);
    } else {
      throw new RuntimeException("Event does not exist");
    }
  }
  String printChildren() {
    String returnString = "";
    returnString += ("\n\n"+ this.parentWindow.name +" HIERARCHY");
    returnString += this.printChildren("");
    return returnString;
  }
  String printChildren(String preString) {
    String returnString = ("\n"+preString+"--"+this + "     " + this.name + "      "+ this.getPosition() + "    " /*this.getAttachment()*/);
    Iterator<Node> it = children.iterator();
    while (it.hasNext()) {
      returnString += it.next().printChildren(preString + "  |");
    }
    return returnString;
  }
  void setSize(Vector2 size_) {
    this.size = size_;
  }
  Vector2 getSize() {
    return this.size;
  }
  void center() {
    this.attachmentPos = new Vector2();
    this.originPos = new Vector2();
  }
  void parent(Node parent_) {
    if (parent_!=null) {
      this.parentWindow.adoptionList.add(new Node[]{parent_, this});
    }
    if (this.parent!=null) {
      this.parentWindow.unadoptionList.add(new Node[]{this.parent, this});
    }
  }
  void adopt(Node child) {
    this.children.add(child);
    this.addLayerChild(child);
    child.parent = this;
    child.setPosition(child.pos);
    child.onAdoption();
  }
  void addLayerChild(Node child) {
    if (!(this.layerMap.keySet().contains(child.layer))) {
      this.layerMap.put(child.layer, new ArrayList<Node>());
    }
    this.layerMap.get(child.layer).add(child);
  }
  private void unadopt(Node child) {
    this.layerMap.get(child.layer).remove(child);
    this.children.remove(child);
  }
  void setPosition(Vector2 pos_) {
    this.parent.setChildPosition(this, pos_);
  }
  void setChildPosition(Node child_, Vector2 pos_) {
    child_.pos = pos_;
  }
  Vector2 getChildPosition(Node child_) {
    return child_.getRelativePosition();
  }
  Vector2 getRelativePosition() {
    return this.pos;
  }

  boolean checkCollision(Vector2 pos_) {
    Vector2 pos = this.getPosition();
    if (pos_.x >= pos.x && pos_.x < pos.x+this.size.x) {
      if (pos_.y>= pos.y && pos_.y < pos.y+this.size.y) {
        return true;
      }
    }
    return false;
  }
  ArrayList<Node> getCollisionChildren(Node collisionNode, Vector2 pos_, Float collisionLayer_) {
    ArrayList<Node> collisionNodes = new ArrayList<Node>();
    for (Node n : this.children) {
      if (n.collisionLayers.contains(collisionLayer_)) {
        if (!(n.equals(collisionNode))) {
          if (n.checkCollision(pos_)) {
            collisionNodes.add(n);
            log(("Collision: " + collisionNode + " " + pos_+ "  -->  " + n + "  " + n.getPosition()), Debug.collisionLog);
          }
        }
      }
    }
    return collisionNodes;
  }
  Vector2 getAttachment() {
    return this.parent.getRootPosition().add(this.parent.getCenter()).add(this.attachmentPos.multiply(this.parent.getCenter())).add(this.parent.getOrigin().inverse());
  }
  Vector2 getRootPosition() {
    return this.getAttachment().add(this.pos);
  }
  Vector2 getOrigin() {
    return this.getCenter().add(this.getCenter().multiply(this.originPos));
  }
  Vector2 getPosition() {
    return this.getAttachment().add(this.getOrigin().inverse()).add(this.parent.getChildPosition(this));
  }
  Vector2 getCenter() {
    return new Vector2(this.size.x/2, this.size.y/2);
  }
  void draw() {
    if (alpha(fill) == 0.0) {
      this.parentWindow.parentPApp.noFill();
    } else {
      this.parentWindow.parentPApp.fill(fill);
    }
    this.parentWindow.parentPApp.stroke(strokeColor);
    this.parentWindow.parentPApp.strokeWeight(strokeWeight);
    if (strokeWeight==0.0) {
      this.parentWindow.parentPApp.noStroke();
    }
    this.parentWindow.parentPApp.rect(this.getPosition().x, this.getPosition().y, this.size.x, this.size.y);
    ArrayList<Float> layersList = new ArrayList<Float>(this.layerMap.keySet());
    Collections.sort(layersList);
    for (Float layer : layersList) {
      for (Node node : this.layerMap.get(layer)) {
        if (node.visible) {
          node.draw();
        }
      }
    }
    if (debugOptions.contains(Debug.positionDots)) {
      try {
        Vector2 pos = this.getPosition();
        this.parentWindow.parentPApp.stroke(0);
        this.parentWindow.parentPApp.strokeWeight(10);
        this.parentWindow.parentPApp.point(pos.x, pos.y);
        this.parentWindow.parentPApp.noStroke();
        //Vector2 origin = this.g();
        //stroke(255, 0, 0);
        //strokeWeight(10);
        //point(origin.x, origin.y);
        this.parentWindow.parentPApp.noStroke();
      }
      catch (Exception e) {
      }
    }
  }
  void process() {
    if (this.parent.sizeMode.equals(Size.inherit)&&!(this.sizeMode.equals(Size.override))) {
      this.sizeMode = Size.inherit;
    }
    if (this.sizeMode==(Size.inherit)) {
      this.size = this.parent.getSize();
    }
    ArrayList<Float> layersList = new ArrayList<Float>(this.layerMap.keySet());
    Collections.sort(layersList);
    for (Float layer : layersList) {
      for (Node node : this.layerMap.get(layer)) {
        if (node.processing) {
          node.process();
        }
      }
    }
  }
  void ready() {
    ArrayList<Float> layersList = new ArrayList<Float>(this.layerMap.keySet());
    for (Float layer : layersList) {
      for (Node node : this.layerMap.get(layer)) {
        node.ready();
      }
    }
  }
  @Override
    String toString() {
    try {
      return ((String.valueOf(this.getClass()).split(sketchFile(sketchPath()).getName())[1])+"("+this.name+")");
    }
    catch(Exception e) {
    }
    return "Could not print";
  }
  ArrayList<Vector2> checkCollisions() {
    return new ArrayList<Vector2>();
  }
}
public enum Size {
  inherit, basic, override
}
