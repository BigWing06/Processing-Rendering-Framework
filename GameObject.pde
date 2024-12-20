public class GameObject extends Node{
  GameObject(Node parent_, Vector2 pos_, Float layer_, Vector2 size_){ // The constructor; Calls the super constructor
    super(parent_,pos_,layer_,size_);
  }
  @Override
  void draw(){
    super.draw();
  }
}
