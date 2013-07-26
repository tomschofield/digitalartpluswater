
//an example extension of the node class
class MatrixNode extends ANode {

  int dia;
  color onColor = #FFFFFF;
  color offColor = #000000;
  boolean mouseOverLock = false;

  //the threshhold above which we will consider a node to be on for the sake of the matrix (out of 255);
  int thresh = 60;


  MatrixNode(int id1, ArrayList connectedNodeIds1, PVector _vec, int _dia) {
    super( id1, connectedNodeIds1, _vec);
    dia = _dia;
  }
  void display() {
    pushStyle();
    noStroke();
    if (isOn) {
      //fill(onColor);
      if (lastAcceptedPacket!=null) {

        fill(lastAcceptedPacket.aColor);
      }
    }
    else {
      fill(offColor);
    }
    ellipse(vec.x, vec.y, dia, dia);
    mouseOver();
    popStyle();
  }
  int writeToMatrix() {
    int writeHigh=0;
    if (lastAcceptedPacket!=null) {
      float red = red(lastAcceptedPacket.aColor);
      float green = green(lastAcceptedPacket.aColor);
      float blue = blue(lastAcceptedPacket.aColor);

      if ((red+green+blue)>(thresh*3)) {
        writeHigh = 1;
      }
      //      if(red>thresh || green>thresh || blue>thresh){
      //       writeHigh = 1; 
      //      }
    }
    return writeHigh;
  }
  void mouseOver() {
    if (dist(mouseX, mouseY, vec.x, vec.y)<dia) {
      if (!mouseOverLock) {
       // debug();
        mouseOverLock=true;
      }
    }
    else {
      mouseOverLock=false;
    }
  }
  void debug() {
    println("///////////////mouse over MatrixNode///////////////");
    println("id: "+id);
    println("isON: "+isOn);
    print("connectedNodeIds: ");
    for (int i=0;i<connectedNodeIds.size();i++) {
      int id = (Integer)connectedNodeIds.get(i);
      print ( id +",");
    }
    println();
    if (lastAcceptedPacket!=null) {
      println("lastAcceptedPacket :");
      lastAcceptedPacket.debug();
    }
    println("packets :");

    for (int i=0;i<packets.size();i++) {
      Packet tempPacket = (Packet)packets.get(i);
      tempPacket.debug();
    }
    println("//////////////////////////////");
    println();
  }
}

