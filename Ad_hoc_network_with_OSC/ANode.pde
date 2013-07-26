//THE MAIN NODE CLASS
class ANode {

  int id;
  ArrayList connectedNodeIds;
  PVector vec;
  ArrayList packets;
  Packet lastAcceptedPacket;
  //TO DO REPLACE WITH FIELDS FROM lastAcceptedPacket
  boolean isOn =true;
  int brightness;
  int hue;
  int saturation;

  ANode(int _id, ArrayList _connectedNodeIds, PVector _vec) {
    id = _id;
    connectedNodeIds = _connectedNodeIds;
    vec = _vec;
    packets = new ArrayList();
  }
  //MAIN UPDATE FUNCTION KEEPS ANY PACKETS DESTINED FOR THIS NODE AND RETURNS ANY OTHERS TO MANAGER CLASS FOR FORWARDING ON
  ArrayList updateAndGetForwardingPackets() {
    ArrayList forwardingPackets;
    forwardingPackets = new ArrayList();
    forwardingPackets.clear();

    for (int i=0;i<packets.size();i++) {
      Packet tempPacket = (Packet) packets.get(i);
      //if the packet is meant for this node, keep it  
      if (tempPacket.targetId ==id) {
        if (lastAcceptedPacket!= null) {
          //check that the time At Origin is more recent than the lastAcceptedPacket so as till kill duplicates
          if (tempPacket.timeAtOrigin > lastAcceptedPacket.timeAtOrigin) {
            //if this packet is destined for this node and is new than the old one update the current packets
            lastAcceptedPacket = (Packet)tempPacket.clone();
          }
          else {
            //do nothing
          }
        }
        else {
          lastAcceptedPacket =  (Packet)tempPacket.clone();
        }
      }
      else {
        //else forward the packet somewhere (flooding)
        tempPacket.life--;
        if (tempPacket.life>=0) {
          forwardingPackets.add(tempPacket);
        }
        else {
          //let it die
          //println("packet dies:");
        }
      }
    }
    //CLEAR OUT THE LIST SO IT CAN BE REPOPULATED LATER
    packets.clear();
   
    return forwardingPackets;
  }
  ArrayList getConnectedNodeIds() {
    return connectedNodeIds;
  }
  //NOT YET IMPLEMENTED
  void setIsOn(boolean _isOn) {
    isOn=_isOn;
  }
  void setBrightness(int _brightness) {
    brightness = _brightness;
  }
  void setHue(int _hue) {
    hue = _hue;
  }
  void setSaturation(int _saturation) {
    saturation = _saturation;
  }

  void addPacket(Packet aPacket) {
    packets.add(aPacket);
  }
  void removePacket(int packetIndex) {
    packets.remove(packetIndex);
  }
  //overloaded version WILL remove most recent packet - not implementeed
  void removePacket() {
  }
  //delete all packets
  void clearPackets() {
    packets.clear();
  }
}

