/**
 adapted from
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 
 */

import oscP5.*;
import netP5.*;
import processing.video.*;


OscP5 oscP5;
Movie movie;

PFont font;
int _numNodes = 64;
NetAddress myRemoteLocation;


int gEntranceNodeId;
int gAddressNodeId;
float gRed;
float gGreen;
float gBlue;
int gId;
PGraphics pg;
//tally of packets added
int count = 0;
void setup() {
  size(640, 360);
  background(0);
  // Load and play the video in a loop
  movie = new Movie(this, "ghost.3gp");
  movie.loop();
  font = loadFont("Serif-18.vlw");

  textFont(font, 18);
  smooth();


  oscP5 = new OscP5(this, 7000);

  myRemoteLocation = new NetAddress("127.0.0.1", 7110);
  pg = createGraphics(8, 8);
    frameRate(30);

}


void draw() {
  background(0);

  //image(movie, 0, 0, width, height);


  noStroke();
  pg.beginDraw();
  pg.background(0);
  pg.image(movie, 0, 0, 8, 8);


  //pg.image(movie, 0, 0, 8, 8);
  pg.endDraw();

  pg.loadPixels();
  int x=0;
  int y=0;
  int squareSize = 8;
  for (int i=0;i<(pg.width*pg.height);i++) {
    fill(pg.pixels[i]);
    
    sendMessageAddPacket(i, i, pg.pixels[i], i);
    rect( x*squareSize, y*squareSize, squareSize, squareSize);
    x++;
    if (x>=pg.width) {
      x=0;
      y++;
    }
  }



  // image(movie, 0, 0, width, height);
  //image(pg, 0, 0, 64, 64);//, width, height);
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
}
void movieEvent(Movie m) {
  m.read();
}

