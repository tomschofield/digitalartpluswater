//more info on the weather class here: http://forum.processing.org/topic/yahoo-weather-some-classes-to-make-it-easier-to-get-what-you-want

/*
//THIS IS THE MAIN RECEIVING APP. IT TAKES OSC MESSAGES AND ADDS THEM TO A NETWORK
YOU CAN CHOOSE TO ADD THE MESSAGE AT ANY NODE POINT AND IT WILL FLOOD THE NETWORK TO TRY TO FIND THE DESTINATION


 SOME PARTS adapted from
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 

//Ad_hoc_network_from_yahoo_weather
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

OscP5 oscP5;
int _numNodes = 64;
NetAddress myRemoteLocation;
PGraphics pg;
//tally of packets added
int count = 0;
PFont f;

// The WeatherGrabber object does the work for us!
YahooWeather weather;

//a set of rought and incomplete categories for wather to match to our pictures
String [] rainLikeWeather = {
  "Rain", "Rain Showers", "Chance of Rain", "Scattered Showers"
};
String [] cloudAndRainLikeWeather = {
  "Chance of Storm", "Storm"
};
String [] cloudLikeWeather = {
  "Partly Cloudy", "Cloudy", "Mostly Cloudy"
};
String [] sunlikeWeather = {
  "Mostly Clear", "Clear", "Fine", "Fair", "Sunny", "Partly Sunny", "Mostly Sunny"
};
String [] snowlikeWeather = {
  "Chance of Snow", "Snow", "Sleet"
};
PImage rain;
PImage cloud;
PImage cloud_and_rain;
PImage sun;
PImage snow;

void setup() {
  size(100, 100);

  // Make a WeatherGrabber object
  //you can find woeids at http://isithackday.com/geoplanet-explorer/index.php?woeid=560743
  String glasgowWOEID ="22465834";
  String dublinWOEID ="560743";
  String skegnessWOEID ="34892";
  String genovaWOEID ="712516";
  
  //make a new weather object with this WOEID
  weather = new YahooWeather(dublinWOEID);
  
  // Tell it to request the weather
  weather.getWeather();

  f = createFont( "Georgia", 16, true);

  rain = loadImage("rain.png");
  cloud= loadImage("cloud.png");
  cloud_and_rain= loadImage("cloud_rain.png");
  sun= loadImage("sun.png");
  snow= loadImage("snow.png");


  oscP5 = new OscP5(this, 7000);

  myRemoteLocation = new NetAddress("127.0.0.1", 7110);
  pg = createGraphics(8, 8);
}

void draw() {
  background(0);
  textFont(f);
  println(weather.getForecastText(1));
  
 
  String condition = getMatchingConditionType(weather.getForecastText(1));
  //println("condition is "+condition);
  int x = 0;
  int y = 0;
  int w = 8;
  int h = 8;


  noStroke();
  pg.beginDraw();
  pg.background(0);

  if (condition.equals("rain")) {
    pg.image(rain, x, y, w, h);
  }
  else if (condition.equals("cloud_and_rain")) {
    pg.image(cloud_and_rain, x, y, w, h);
  }
  else if (condition.equals("cloud")) {
    pg.image(cloud, x, y, w, h);
  }
  else if (condition.equals("sun")) {
    pg.image(sun, x, y, w, h);
  }
  else if (condition.equals("snow")) {
    pg.image(snow, x, y, w, h);
  }
  //pg.image(movie, 0, 0, 8, 8);
  pg.endDraw();

  pg.loadPixels();

  x=0;
  y=0;
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
}

String getMatchingConditionType(String conditionToMatch) {
  String result = "";
  for (int i=0;i<rainLikeWeather.length;i++) {
    if (conditionToMatch.equals(rainLikeWeather[i]) )result="rain";
  }
  for (int i=0;i<cloudAndRainLikeWeather.length;i++) {
    if (conditionToMatch.equals(cloudAndRainLikeWeather[i])) result="cloud_and_rain";
  }
  for (int i=0;i<cloudLikeWeather.length;i++) {
    if (conditionToMatch.equals(cloudLikeWeather[i])) result="cloud";
  }
  for (int i=0;i<sunlikeWeather.length;i++) {
    if (conditionToMatch.equals(sunlikeWeather[i])) result="sun";
  }
  for (int i=0;i<snowlikeWeather.length;i++) {
    if (conditionToMatch.equals(snowlikeWeather[i])) result="snpw";
  }

  return result;
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
/*
a probably incomplete list of conditions
 images/weather/chance_of_rain.gif
 images/weather/sunny.gif
 images/weather/mostly_sunny.gif
 images/weather/partly_cloudy.gif
 images/weather/mostly_cloudy.gif
 images/weather/chance_of_storm.gif
 images/weather/rain.gif
 images/weather/chance_of_rain.gif
 images/weather/chance_of_snow.gif
 images/weather/cloudy.gif
 images/weather/mist.gif
 images/weather/storm.gif
 images/weather/thunderstorm.gif
 images/weather/chance_of_tstorm.gif
 images/weather/sleet.gif
 images/weather/snow.gif
 images/weather/icy.gif
 images/weather/dust.gif
 images/weather/fog.gif
 images/weather/smoke.gif
 images/weather/haze.gif
 images/weather/flurries.gif*/
