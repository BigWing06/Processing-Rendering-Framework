public class Vector2 {
  float x; // Value one
  float y; // Value two
  int id; // Used to compare Vector2s to each other
  
  Vector2() { // Constructor for create a Vector2 with x and y both set to zero
    this.createVector(0, 0);
  }
  
  Vector2(Number x_, Number y_) { // Constructor for different x and y values
    this.createVector(x_, y_);
  }
  
  Vector2(Number x_) { // Constructor for creating a Vector2 where the x and y values are the same
    this.createVector(x_, x_);
  }
  
  private void createVector(Number x_, Number y_) { // The private method that creates all Vector2s and their ids
    this.x=x_.floatVValue();
    this.y=y_.floatValue();
    this.id = int(str(int(this.x))+str(int(this.y)));
  }
  
  Vector2 multiply(float factor) { // Multiplies a Vector2 by a single factor
    return new Vector2(this.x*factor, this.y*factor);
  }
  
  Vector2 multiply(Vector2 factor) { // Multiplies two Vector2s
    return new Vector2(this.x*factor.x, this.y*factor.y);
  }
  
  Vector2 divide(float factor) { // Divides a Vector2 by a factor
    return new Vector2(this.x/factor, this.y/factor);
  }
  
  Vector2 divide(Vector2 factor) { // Divides a Vector2 by another Vector2
    return new Vector2(this.x/factor.x, this.y/factor.y);
  }
  
  Vector2 add(Vector2 num) { // Adds two Vector2s
    return new Vector2(this.x+num.x, this.y+num.y);
  }
  
  Vector2 inverse() { // Returns the Vector2 multiplied by -1
    return new Vector2(this.x*-1, this.y*-1);
  }
  
  @Override
    public boolean equals(java.lang.Object o) { // Overridden equal function, compares two objects to see if they are the same
    if (o==this) {
      return true;
    }
    if (!(o instanceof Vector2)) {
      return false;
    }
    Vector2 v = (Vector2) o;
    return (v.x == this.x && v.y == this.y);
  }
  
  @Override // Returns the id; Used in object comparison
    public int hashCode() {
    return (int)this.id;
  }
  
  @Override
    String toString() { // Returns a formatted string value of the Vector2
    return ("Vector 2: " + this.x + "  " + this.y);
  }
}

public class EventData {
  Character k = null; // The character pressed 
  Vector2 mousePos = null; // The mouse position
  Integer mouseBtn = null; // The mouse button pressed
  String type = null; // The type of event
  EventData(String type_){ // The constructor; Sets the type
    this.type = type_;
  }
  
  EventData setKey(Character k_){ // Sets the key pressed
    this.k = k_;
    return this;
  }
  
  EventData setMousePos(Vector2 mousePos_){ // Sets the mouse position
    this.mousePos = mousePos_;
    return this;
  }
  
  EventData setMouseBtn(Integer mouseBtn_){ // Sets the mouse button pressed
    this.mouseBtn = mouseBtn_;
    return this;
  }
}

@FunctionalInterface
  interface Method { // Stores a method to be run
  void run();
}