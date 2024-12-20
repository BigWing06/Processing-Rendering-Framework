public class TileMap extends Node {
  HashMap<Vector2, Node> tileMap = new HashMap<Vector2, Node>(); // Contains the children Nodes paired with their location
  Vector2 scale; // The scale of the tiles
  
  TileMap(Node parent_, Float layer_, Vector2 scale_, Vector2 pos_, Vector2 size_) { // The constructor; sets variables
    super(parent_, pos_, layer_, size_.multiply(scale_));
    this.scale = scale_;
  }
  
   Vector2 getChildLocation(Node child_) { // Returns the child position as a position (Not a location)
    return this.posToLoc(child_.getRelativePosition());
  }
  
  @Override // Sets the child's position by converting from a location number to a position number
    void setChildPosition(Node child_, Vector2 pos_) {
    //this.tileMap.remove(child_.pos);
    child_.pos = this.locToPos(pos_);
    this.tileMap.put(this.posToLoc(child_.getRelativePosition()), child_);
  }
  
  void unadopt(Vector2 loc_) { // Removes the child from the tileMap
    Node child = tileMap.get(loc_);
    tileMap.remove(loc_);
  }
  
  Node get(Vector2 loc_) { // Returns the node at that location if it exsits
    if (tileMap.keySet().contains(loc_)) {
      return tileMap.get(loc_);
    }
    return null;
  }
  
  @Override
    void adopt(Node child_) { // Puts the child in tileMap, changes size mode to inherit, and adopts the child
    super.adopt(child_);
    this.tileMap.put(this.posToLoc(child_.getRelativePosition()), child_);
    child_.parent = this;
    if(child_.sizeMode != Size.override){
    child_.sizeMode = Size.inherit;
    }
  }
  
  @Override
    Vector2 getSize() { // Returns the scale of the tiles
    return  this.scale;
  }
  
  Vector2 posToLoc(Vector2 pos_) { // Converts a position to a location
    return pos_.divide(this.scale);
  }
  
  Vector2 locToPos(Vector2 loc_) { // Converts a location to a position
    return loc_.multiply(this.scale);
  }
}
