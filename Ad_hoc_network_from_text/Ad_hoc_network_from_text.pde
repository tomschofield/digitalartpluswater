/**
 //THIS EXAMPLE SEND DRAWS TEXTS A CHARACTER AT A TIME TO THE SCREEN AND
 SENDS AN 8 * 8 SAMPLE TO THE MATRIX VIA OSC NETWORK MESSAGES
 
 adapted from
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 
 
 //Ad_hoc_network from text
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
//import libraries
import oscP5.*;
import netP5.*;


OscP5 oscP5;


PFont font;

int _numNodes = 64;
NetAddress myRemoteLocation;

//THE STRING HOLDING OUR TEXT
String word;

//WHICH CHARACTER WE ARE UP TO AT THIS PIONT
int charIndex = 0;
//HOW OFTEN TO UPDATE AND MOVE ON TO NEXT CHARACTER
int updateEveryNFrames = 2;
PGraphics pg;
//tally of packets added
int count = 0;
void setup() {
  size(64, 64);
  // Load and play the v
  font = createFont("Minecraftia.ttf", 8);

  //THIS WOULD WORK BETTER WITH A CUSTOM FONT
  textFont(font, 8);
  smooth();

  //RECEIVE ON PORT 7000 NOT USED CURRENTLY
  oscP5 = new OscP5(this, 7000);
  //SEND TO 7110

    myRemoteLocation = new NetAddress("127.0.0.1", 7110);

  //WRITE TEXT TO A GRAPHICS BUFFER SO WE CAN CHOOSE TO SOMETHING ELSE WITH THIS SCREEN

  //OUR WORD - 
  word = "HELLO WORLD";
  frameRate(30  );
}


void draw() {
  background(0);
  noStroke();

  String thisChar = str(word.charAt(charIndex));
  fill(255);
  text(thisChar, 0, 8);

  int x=0;
  int y=0;
  int squareSize = 1;
  loadPixels();
  int onCount=0;
  boolean [] ons = new boolean[64];
  for (int i=0;i<64;i++) {
      if (brightness(get(x, y))>0) {
        ons[onCount] = true;

     //   println("found");
      }
      else {
        ons[onCount] = false;
      }
    x++;
    if (x>=8) {
      y++;
      x=0;
    }
    onCount++;
  }


  x=0;
  y=0;
  rectMode(CORNER);
  for (int i=0;i<ons.length;i++) {
    
    if (ons[i]) {
      fill(255); 
      sendMessageAddPacket(i, i, color(255), i);
     // println("on");
    }
    else {
      fill(0); 
            sendMessageAddPacket(i, i, color(0), i);

     // println("off");
    }
    rect( x*squareSize, y*squareSize, squareSize-1, squareSize-1);
    int xPos=x*squareSize;
    int yPos= y*squareSize;
   // println(x+" "+xPos+" "+" "+y+" "+ yPos);

    x++;
    if (x>=8) {
      x=0;
      y++;
    }
  }



  if (frameCount % updateEveryNFrames ==0) {
    charIndex++;
    if (charIndex>=word.length())charIndex=0;
  }

}

//MESSAGE SENDING FUNCTION - THE MESSAGE WILL BECOME A NETWORK PACKET IN THE AD HOC NETWORK
void sendMessageAddPacket(int entranceNodeId, int addressNodeId, color _aColor, int _id) {
  //don't send a message to a non existant node
  if (entranceNodeId<_numNodes && addressNodeId<_numNodes && _id<_numNodes) {
    OscMessage myMessage = new OscMessage("/addPacket");
    //type tag will be iifffi

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

