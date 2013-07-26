class NetworkManager {
  ArrayList matrixNodes;
  int numNodes;
  long numAdded=0;
  String pMessage ="";
  NetworkManager(int _numNodes) {
    numNodes = _numNodes;
  }
  void setupNetwork() {
    matrixNodes = new ArrayList();
    int x = 0;
    int y = 0;
    float spacing = width/ (1+ sqrt(_numNodes));
    for (int i=0;i<_numNodes;i++) {
      // = spacing + (i*spacing);
      float thisX  = spacing + (x*spacing);
      float thisY  = spacing + (y*spacing);
      ArrayList connections = new ArrayList();

      connections.add((int) random((_numNodes)-1));
      connections.add((int) random((_numNodes)-1));

      MatrixNode tempNode = new MatrixNode (i, connections, new PVector (thisX, thisY), 30);
      matrixNodes.add(tempNode);
      x++;
      if (x>=sqrt(_numNodes)) {
        y++;
        x=0;
      }
    }
  }
  void updateNetwork() {
    //for each node get the packets to forward
    for (int i=0;i<matrixNodes.size();i++) {
      MatrixNode tempNode = (MatrixNode) matrixNodes.get(i);
      ArrayList _forwardingPackets = new ArrayList();
      //now we have a list of packets to forward - we already have a list of places for them to go
      _forwardingPackets = tempNode.updateAndGetForwardingPackets();
      //println("forwarding "+_forwardingPackets.size()+" from node #"+i);
      //here is that list of places to go
      ArrayList _connectedNodeIds = new ArrayList();
      _connectedNodeIds = tempNode.getConnectedNodeIds();

      //for each packet
      for (int k=0;k<_forwardingPackets.size();k++) {
        //get the packet
        Packet tempPacket = (Packet) _forwardingPackets.get(k);
        //then forward it to each other node
        for (int j=0;j<_connectedNodeIds.size();j++) {
          ANode targetTempNode; 
          //here's the address of the node we are setting it to (it gets sent to all connected nodes
          int tempNodeId = (Integer) _connectedNodeIds.get(j);
          targetTempNode = (MatrixNode) matrixNodes.get(tempNodeId);
          //lets just check that we aren't sending it back where it just came from
          if (tempNodeId!=tempPacket.fromId) {
            //tell the packet that this is where it just came from so it doesn't get routed back here once we've sent it on
            Packet clonedPacket = (Packet)tempPacket.clone();
            clonedPacket.fromId = tempNode.id;
            targetTempNode.addPacket(clonedPacket);
            numAdded++;
            //forwardPacket(tempPacket, tempNodeId);
          }
          else {
            //println("skip");
          }
        }
      }

      //get rid of all the packets for this node except the one that stays here
      tempNode.clearPackets();
      //matrixNodes.set(i,tempNode);
    }
    //println("numAdded "+numAdded);
  }
  void managePackets() {
  }
  void displayNodes() {
    for (int i=0;i<matrixNodes.size();i++) {
      MatrixNode tempNode = (MatrixNode) matrixNodes.get(i);
      tempNode.display();
    }
  }

  void writeToMatrix() {
    
    //horribly inefficient way of checking that the message is different before we change it
    String serialMessage ="";
    int aByte = 0; 
    int spacesToShift =0;
    for (int i=0;i<matrixNodes.size();i++) {
      MatrixNode tempNode = (MatrixNode) matrixNodes.get(i);
      serialMessage+=str(tempNode.writeToMatrix());
    }

    if (!pMessage.equals(serialMessage)) {
      
      //nasty-ass bitwise operation - probably really inefficient way of doing this
      for (int i=0;i<matrixNodes.size();i++) {
        MatrixNode tempNode = (MatrixNode) matrixNodes.get(i);
        //serialMessage+=str(tempNode.writeToMatrix());
        int bit = tempNode.writeToMatrix();
        aByte += bit <<spacesToShift;

        spacesToShift++;
        if (spacesToShift>=8) {
          //send byte
          byte castByte = (byte) aByte;

          aByte=0;
          int space = spacesToShift-1;

          println(space+" "+binary(castByte));
          myPort.write(castByte);
          //send message

            spacesToShift=0;
        }
      }

      pMessage = serialMessage ;
    }

  }
  //entranceNodeId is where you want to send the packet too initially, addressNodeID is where you want it to end up
  void addPacket(int entranceNodeId, int addressNodeId, color aColor, int _id) {
    Packet packetToAdd = new Packet(true, addressNodeId, aColor, _id);
    ANode targetTempNode;
    targetTempNode = (MatrixNode) matrixNodes.get(entranceNodeId);
    targetTempNode.addPacket(packetToAdd);
  }
  void addPacket(Packet aPacket, int y) {
  }
}

