/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
float alph=0;
void setup() {
  size(400, 400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 7000);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
   myRemoteLocation = new NetAddress("127.0.0.1",7110);
}


void draw() {
  background(0);  
   OscMessage myMessage = new OscMessage("/mouse");
   myMessage.add(mouseX);
  // myMessage.add(map(mouseX,0,width,0,1));
   myMessage.add(mouseY);
   //   OscMessage myMessage = new OscMessage(mouseX+"THIS"+mouseY+"\r");
   oscP5.send(myMessage, myRemoteLocation); 
}//

