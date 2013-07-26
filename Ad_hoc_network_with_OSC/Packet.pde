//a kind of struct
class Packet implements Cloneable {

  boolean state;
  int targetId;
  color aColor;
  int fromId=-1;
  long timeAtOrigin;
  int id;
  //number of steps the packet will make until it is allowed to die off
  int life = 15;
  Packet(boolean _state, int _targetId, color _aColor, int _id) {
    state = _state;
    targetId = _targetId;
    aColor = _aColor;
    timeAtOrigin = millis();
    id = _id;
  }
  public Object clone() {  
    try {  
      return super.clone();
    }
    catch(Exception e) { 
      return null;
    }
  }
  void debug() {
    println("id: "+id);
    println("targetId: "+targetId);
    println("fromId: "+fromId);
    println("timeAtOrigin: "+timeAtOrigin);
  }
}

