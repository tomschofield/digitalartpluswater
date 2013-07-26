
/*
//adapted from
 Reading a serial ASCII-encoded string.
 created 13 Apr 2012
 by Tom Igoe
 
 It looks for an ASCII string of comma-separated values.
 and uses them to write to a max 7219 led driver chip 
 */
#include "LedControl.h"
LedControl lc=LedControl(12,11,10,1);
int row =0;
int col =7;
int arrayIndex = 0;

void setup() {
  // initialize serial:
  Serial.begin(9600);
  // make the pins outputs:
  lc.shutdown(0,false);
  /* Set the brightness to a medium values */
  lc.setIntensity(0,8);
  /* and clear the display */
  lc.clearDisplay(0);
}

void loop() {
  // if there's any serial available, read it:
  while (Serial.available() > 0) {
    
    byte aByte = Serial.read();
     lc.setRow(0,row,aByte);
      row++;
      if(row>=8){
       row=0; 
      }
     
  }
}









