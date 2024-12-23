public class Window extends Node {
  String childrenHierarchyText=""; // The text to be displayed before the hierarchy is printed
  PApplet parentPApp; // The PApplet that the window is within, for reference in drawing
  Boolean debug = false;
  ArrayList<Method> actionQueue = new ArrayList<Method>(); //Queue of actions that is being processed
  ArrayList<Method> futureActionQueue = new ArrayList<Method>();//Queue of actions to run on next tick
  ArrayList<Node[]> adoptionList = new ArrayList<Node[]>(); // The list of Nodes to be adopted; First node (key) is for adopter, second (value) is adoptee
  ArrayList<Node[]> unadoptionList = new ArrayList<Node[]>(); // The list of Nodes to be undaopted; First node (key) is for unadopter, second (value) is unadoptee
  ArrayList<Node> masterNodeList = new ArrayList<Node>(); //***
  
  Window(PApplet parentPApp_) { // The constructor; Sets variables
    super.setupNode(this, new Vector2(), 0.0, new Vector2(parentPApp_.width, parentPApp_.height));
    super.parentWindow = this;
    this.parentPApp = parentPApp_;
  }
  
  @Override
    Vector2 getRootPosition() { // Returns the distance from the top left corner (always (0,0))
    return new Vector2(0, 0);
  }
  
  @Override
    Vector2 getPosition() { // Returns the top left corner (always (0,0))
    return new Vector2(0, 0);
  }
  
  String getChildrenHierarchyText() { // Returns the values to print before the children hierarchy
    return this.childrenHierarchyText;
  }
  
  void evaluateAdoptions() { // Adopts children from the adoptionList; Unadopts children from the unadoptionList
    for (Node[] pair : this.unadoptionList) {
      Node oldParent = pair[0];
      Node unadoptee = pair[1];
      log("Unadopted: "+unadoptee + "  -->  "+ oldParent, Debug.adoptionLog);
      oldParent.unadopt(unadoptee);
    }

    for (Node[] pair : this.adoptionList) {
      Node newParent = pair[0];
      Node adoptee = pair[1];
      log("Adopted: "+adoptee + "  -->  "+ newParent, Debug.adoptionLog);
      newParent.adopt(adoptee);
      if (!(masterNodeList.contains(adoptee))){
        masterNodeList.add(adoptee);
      }
      if (pair[0]==null){
        masterNodeList.remove(adoptee);
      }
    }
    if (this.unadoptionList.size() != 0 || this.adoptionList.size() != 0) {
      this.childrenHierarchyText = this.printChildren();
    }
    this.unadoptionList = new ArrayList<Node[]>();
    this.adoptionList = new ArrayList<Node[]>();
  }
  
  void addAction(Method action){
    this.futureActionQueue.add(action);
  }

  @Override
    void process() { // Runs evaluateAdoptions and runs process in its children
    super.size = new Vector2(this.parentPApp.width, this.parentPApp.height);
    this.evaluateAdoptions();
    for(Method action:this.actionQueue){
      action.run();
    }
    this.actionQueue = this.futureActionQueue;
  }
}
