/**
 //THIS IS THE MAIN RECEIVING APP. IT TAKES OSC MESSAGES AND ADDS THEM TO A NETWORK
 YOU CAN CHOOSE TO ADD THE MESSAGE AT ANY NODE POINT AND IT WILL FLOOD THE NETWORK TO TRY TO FIND THE DESTINATION
 
 
 SOME PARTS adapted from
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 
 
 //Ad_hoc_network_with_osc
 //Copyright (C) <2012>  <Tom Schofield>
 //
 //    This program is free software: you can redistribute it and/or modify
 //    it under the terms of the GNU General Public License as published by
 //    the Free Software Foundation, either version 3 of the License, or
 //    (at your option) any later version.
 //
 //    This program is distributed in the hope that it will be useful,
 //    but WITHOUT ANY WARRANTY; without even the implied warranty of
 //    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 //GNU General Public License for more details.
 //
 //You should have received a copy of the GNU General Public License
 //along with this program.  If not, see <http://www.gnu.org/licenses/>
 
 */

import oscP5.*;
import netP5.*;
import processing.serial.*;

Serial myPort;
OscP5 oscP5;

//8*8 MATRIX MAKES 64 NODES
int _numNodes = 64;
int numPackets = 64;
//ArrayList matrixNodes;
NetworkManager manager;
boolean useSerial =true;

void setup() {
  size(500, 500);
  smooth();

  //receive OSC on port 7110
  oscP5 = new OscP5(this, 7110);

  if (useSerial) {
    // Open whatever port is the one you're using.
    //println(Serial.list());
    //change this number to choose the correct serial device
    String portName = Serial.list()[4];
    myPort = new Serial(this, portName, 9600);
  }
  //MANAGER IS THE MAIN CLASS FOR HANDLING THE NETWORK
  manager = new NetworkManager(_numNodes);
  manager.setupNetwork();

  //OPTIONALLY ADD SOME PACKETS TO THE NETWORK WITH RANDOM COLOURS
  for (int i=0;i<numPackets;i++) {
    color c1 = color((int) random(255), (int) random(255), (int) random(255));
    //UNCOMMENT TO ADD AT A RANDOM POINT
    //manager.addPacket((int) random(_numNodes-1), i, c1, i);

    //OR UNCOMMENT TO ADD PACKETS DIRECTLY TO WHERE YOU WANT THEM TO GO
    //manager.addPacket(i,i,c1, i);
  }
  frameRate(30);
}

void draw() {
  background(#000000);
  manager.updateNetwork();
  manager.displayNodes();
  if (useSerial) {
    manager.writeToMatrix();
  }
}
void keyPressed() {
}
//RECIEVE IN-COMING PACKETS AND ADD THEM TO THE NETWORK
void oscEvent(OscMessage theOscMessage) {
  ////println(" message: "+theOscMessage);
  ////println(" typetag: "+theOscMessage.typetag());
  //ACCEPT ONLY IF THE PACKET HAS THE RIGHT TYPE TAG - IE IT CONTAINS THE RIGHT KIND OF DATA STRUCTURE
  if (theOscMessage.checkTypetag("iifffi")) {
    ////println("adding packet");
    Packet tempPacket;
    int entranceNodeId = theOscMessage.get(0).intValue(); 
    int addressNodeId = theOscMessage.get(1).intValue(); 
    color _aColor = color (theOscMessage.get(2).floatValue(), theOscMessage.get(3).floatValue(), theOscMessage.get(4).floatValue() );
    int _id = theOscMessage.get(5).intValue(); 

    manager.addPacket(entranceNodeId, addressNodeId, _aColor, _id);
  }
  else {
    //println("invalid type tag");
  }
}

void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  //println("got msg" +frameCount+" "+inByte);
}

