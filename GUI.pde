public class Button extends Node{
  Text2D displayText; // The text that will be on the button
  Vector2 padding; // The padding around the text
  color defaultFill; // The color of the button at a resting state
  color onHoverFill; // The color of the button on hover
  color onClickFill; // The color of the button on click
  
  Button(Node parent_, Vector2 pos_, float layer_, Vector2 size_, String text_){ // The constructor; sets variables and events
    super(parent_, pos_, layer_, size_);
    this.setDefaultColors();
    this.displayText = new Text2D(this, new Vector2(), text_, super.size.y, 1.0);
    this.displayText.center();
    
    // These are the events that get created for a button // 
    super.createEvent(new Event(this,"MousePressed", this::onMouseClicked));
    super.createEvent(new Event(this,"MouseReleased", this::onMouseReleased));
    super.createEvent(new Event(this,"MouseHover",this::onMouseHover));
    super.createEvent(new Event(this,"MouseLeave",this::onMouseLeave));
  }
  
  void setDefaultColors(){ // Sets the button fills to the default button colors
   this.defaultFill = color(230);
   this.onHoverFill = color(180);
   this.onClickFill = color(125);
  }
  
  @Override
  void ready(){ // Sets the padding, size, fill, and stroke of the button; called after the WindowManager calls ready
    this.padding = new Vector2(this.displayText.fontSize/5);
    super.setSize(new Vector2((this.displayText.text.length()*this.displayText.fontSize)/2+this.padding.x, this.displayText.fontSize+this.padding.y));
    super.fill = color(255);
    super.strokeColor = color(0);
    super.strokeWeight = 8;
  }
  
  void onMouseClicked(EventData e){ // Called on mouse click, changes fill, should be overriden
    print(super.name);
    super.fill = this.onClickFill;
  }
  
  void onMouseReleased(EventData e){ // Called on mouse released, changes fill, should be overridden
   if (super.mouseOver){
     super.fill = this.onHoverFill;
   }else{
     super.fill = this.defaultFill; 
   } 
  }
  
  void onMouseHover(EventData e){ // Called on mouse hover, changes fill, should be overridden
    super.fill = this.onHoverFill;
  }
  
  void onMouseLeave(EventData e){ // Called when the mouse leaves hovering, changes fill, should be overridden
   super.fill = this.defaultFill; 
  }
}
