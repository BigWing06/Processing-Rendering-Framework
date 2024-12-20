public class Rect2D extends Shape2D {
  Vector2 size;
  Rect2D(Node parent_, Vector2 pos_, float layer_, Vector2 size_) {
    super(parent_, pos_, layer_, size_);
  }
}
public class Text2D extends Shape2D {
  Vector2 pos;
  float fontSize; // The size for the font
  String text; // The text that should be displayed
  Node parent;
  Vector2 textAlign = new Vector2(LEFT, TOP); // The location the text should be drawn from
  
  Text2D(Node parent_, Vector2 pos_, String text_, float fontSize_, float layer_) { // The constructor class; Sets variables
    super(parent_, pos_, layer_, new Vector2(0, 0));
    this.fontSize = fontSize_;
    this.text=text_;
    this.parent=parent_;
  }
  
  @Override
  void center(){ // Aligns the text to the center
    super.center();
    this.textAlign = new Vector2(CENTER);
  }
  
  @Override
    void draw() { // Draws the actual text
    super.parentWindow.parentPApp.fill(super.fill);
    super.parentWindow.parentPApp.textAlign((int)this.textAlign.x, (int)this.textAlign.y);
    super.parentWindow.parentPApp.textSize(this.fontSize);
    super.parentWindow.parentPApp.text(this.text, super.getPosition().x, super.getPosition().y);
  }
}

public class Shape2D extends Node {
  Shape2D(Node parent_, Vector2 pos_, Float layer_, Vector2 size_){ // Runs the super constructor
    super(parent_, pos_, layer_, size_);
  }

}
