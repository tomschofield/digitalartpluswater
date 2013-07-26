/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
PFont font;

import oscP5.*;
import netP5.*;
String msg;
float x, y, z;
OscP5 oscP5;
NetAddress myRemoteLocation;
float alph=0;
void setup() {
  size(800, 400);
  frameRate(25);
  font = loadFont("Serif-72.vlw");
  textFont(font, 36);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 3333);
  msg="";
}


void draw() {
  background(0);
  fill(255);
  text(str(x), 40, 100);
  text(str(y), 40, 120);
  text(str(z), 40, 140);
  ellipse(map(x, 0, 1, 0, width), map(y, 0, 1, 0, height), 140-(20*z), 140-(20*z));
}//




void oscEvent(OscMessage theOscMessage) {

  println(theOscMessage);
  
 /* println(theOscMessage.get(0).stringValue());
   println(theOscMessage.get(1).intValue());
  println(theOscMessage.get(2).floatValue());


  //msg=str(theOscMessage.get(0).floatValue())+str(theOscMessage.get(1).floatValue())+str(theOscMessage.get(2).floatValue());

  msg=str(theOscMessage.get(2).floatValue());
  if(theOscMessage.get(0).stringValue().equals("right_lower_arm")){
  x=theOscMessage.get(2).floatValue();
  y=theOscMessage.get(3).floatValue();
  z=theOscMessage.get(4).floatValue();
  }*/
}

