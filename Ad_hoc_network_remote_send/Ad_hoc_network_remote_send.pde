/**
 adapter from
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 
 and ControlP5 Textfield
 * by Andreas Schlegel, 2012
 * www.sojamo.de/libraries/controlp5
 */

import oscP5.*;
import netP5.*;
import controlP5.*;

OscP5 oscP5;
ControlP5 cp5;

PFont font;
int _numNodes = 64;
NetAddress myRemoteLocation;


int gEntranceNodeId;
int gAddressNodeId;
float gRed;
float gGreen;
float gBlue;
int gId;

//tally of packets added
int count = 0;
void setup() {
  size(640, 480);

  font = loadFont("Serif-18.vlw");
  textFont(font, 18);
  smooth();

  cp5 = new ControlP5(this);

  setupInputs();
  oscP5 = new OscP5(this, 7000);

  myRemoteLocation = new NetAddress("127.0.0.1", 7110);
}


void draw() {
  background(0);  
  int xShift = 280;
  int yShift = 118;
  text("entranceNodeId: "+gEntranceNodeId, xShift, yShift);
  text("addressNodeId: "+gAddressNodeId, xShift, yShift+60);
  text("red: "+gRed, xShift, yShift+120);
  text("green: "+gGreen, xShift, yShift+180);
  text("blue: "+gBlue, xShift, yShift+240);
  text("packetId: "+gId, xShift, yShift+300);
}

void sendMessageAddPacket(int entranceNodeId, int addressNodeId, color _aColor, int _id) {
  //don't send a message to a non existant node
  if (entranceNodeId<_numNodes && addressNodeId<_numNodes && _id<_numNodes) {
    OscMessage myMessage = new OscMessage("/addPacket");
    //type tag will be bifffi

    myMessage.add(entranceNodeId);
    myMessage.add(addressNodeId);
    myMessage.add(red(_aColor));
    myMessage.add(green(_aColor));
    myMessage.add(blue(_aColor));
    myMessage.add(_id);

    oscP5.send(myMessage, myRemoteLocation); 
    count++;
  }
  else {
    println ("WARNING: you are trying to send a message to a non existant node. the message has not been sent");
  }
}
void keyPressed() {
  color c1 = color((int) random(255), (int) random(255), (int) random(255));
  //sendMessageAddPacket(count, count, c1, count);
}

void setupInputs() {
  //local font for GUI
  PFont font = createFont("arial", 20);
  cp5.addTextfield("entrance_Node_Id")
    .setPosition(20, 100)
      .setSize(200, 40)
        .setFont(font)
          .setFocus(true)
            .setAutoClear(false)
              .setColor(color(255, 0, 0))
                ; 

  cp5.addTextfield("address_Node_Id")
    .setPosition(20, 160)
      .setSize(200, 40)
        .setFont(font)
          .setAutoClear(false)
            .setColor(color(255, 0, 0))
              ; 
  cp5.addTextfield("red")
    .setPosition(20, 220)
      .setSize(200, 40)
        .setFont(font)
          .setAutoClear(false)
            .setColor(color(255, 0, 0))
              ; 
  cp5.addTextfield("green")
    .setPosition(20, 280)
      .setSize(200, 40)
        .setFont(font)
          .setAutoClear(false)
            .setColor(color(255, 0, 0))
              ; 
  cp5.addTextfield("blue")
    .setPosition(20, 340)
      .setSize(200, 40)
        .setFont(font)
          .setAutoClear(false)
            .setColor(color(255, 0, 0))
              ; 
  cp5.addTextfield("packetId")
    .setPosition(20, 400)
      .setSize(200, 40)
        .setFont(font)
          .setAutoClear(false)
            .setColor(color(255, 0, 0))
              ;

  cp5.addBang("send")
    .setPosition(470, 100)
      .setSize(80, 40)
        .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
          ;
}

public void send() {
  //cp5.get(Textfield.class,"textValue").clear();
  //println(cp5.get(Textfield.class, "packetId").getStringValue());
  color c1 = color(gRed, gGreen, gBlue);

  sendMessageAddPacket(gEntranceNodeId, gAddressNodeId, c1, gId);
  println("clearing");
  cp5.get(Textfield.class, "entrance_Node_Id").clear();
  cp5.get(Textfield.class, "address_Node_Id").clear();
  cp5.get(Textfield.class, "red").clear();
  cp5.get(Textfield.class, "green").clear();
  cp5.get(Textfield.class, "blue").clear();
  cp5.get(Textfield.class, "packetId").clear();
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Textfield.class)) {

    //    gEntranceNodeId;
    //    gAddressNodeId;
    //    gRed;
    //    gGreen;
    //    gBlue;
    //    gId;
    if ( theEvent.getName().equals("entrance_Node_Id")) {
      gEntranceNodeId = int(theEvent.getStringValue());
    }
    else if (theEvent.getName().equals("address_Node_Id")) {
      gAddressNodeId = int(theEvent.getStringValue());
    }
    else if (theEvent.getName().equals("red")) {
      gRed = float(theEvent.getStringValue());
    }
    else if (theEvent.getName().equals("green")) {
      gGreen = float(theEvent.getStringValue());
    }
    else if (theEvent.getName().equals("blue")) {
      gBlue = float(theEvent.getStringValue());
    }
    else if (theEvent.getName().equals("packetId")) {
      gId = int(theEvent.getStringValue());
    }
  }
}

