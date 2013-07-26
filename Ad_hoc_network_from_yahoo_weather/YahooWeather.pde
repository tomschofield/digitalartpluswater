
XML xml;

// A WeatherGrabber class
class YahooWeather {

  int temperature = 0;
  //String weather = "";
  String WOEID;

  String title;
  PVector latLong;
  String logoLink;
  String pubDate;
  String pictureLink;

  //an object representing a day's yahoo weather information
  YWeather [] yWeathers;

  YahooWeather(String _WOEID) {
    WOEID = _WOEID;
    //api seems to return Forecast info plus 5 day forecast (which weirdly starts today anyway)
  }

  // Make the actual XML request
  void getWeather() {

    String url = "http://weather.yahooapis.com/forecastrss?w="+WOEID;
    //"http://xml.weather.yahoo.com/forecastrss?p=" + zip;
    String[] lines = loadStrings(url);
    // Turn array into one long String
    String rawxml = join(lines, "" ); 
    String cleanXml = "";
    //hack to fix namespace problem which resulted in '[Fatal Error] :1:92: The prefix "yweather" for element "yweather:condition" is not bound.'
    for (int i=0;i<rawxml.length();i++) {
      if (rawxml.charAt(i)==':') {
        cleanXml+="_";
      }
      else {
        cleanXml+=rawxml.charAt(i);
      }
    }

    xml = parseXML(cleanXml);
    //println(xml);
    XML channel  = xml.getChild("channel");
    XML item = channel.getChild("item");
    //println(item.listChildren() );

    XML[] forecasts = item.getChildren("yweather_forecast");

    yWeathers = new YWeather [forecasts.length+1];

    XML atitle  =  item.getChild("title");
    title = atitle.getContent();

    XML lat  =  item.getChild("geo_lat");
    XML along  =  item.getChild("geo_long");
    latLong = new PVector( float(lat.getContent()), float(along.getContent()  ));

    XML apubDate  =  item.getChild("pubDate");
    pubDate = apubDate.getContent();

    //    XML apictureLink  =  item.getChild("description");
    //    pictureLink = apictureLink.getContent();
    //        println("pictureLink is "+pictureLink);

    XML ayweather = item.getChild("yweather_condition");
    println(ayweather);

    int aCode = ayweather.getInt("code");
    String aDate = ayweather.getString("date");
    int aTemp = ayweather.getInt("temp");
    String aText = ayweather.getString("text");

    yWeathers[0] = new YWeather(aCode, aDate, "no day", 999, 999, aText, aTemp, false);


    for (int i=0;i<forecasts.length;i++) {
      XML aForecast = forecasts[i];
      aCode = aForecast.getInt("code");
      aDate = aForecast.getString("date");
      String aDay = aForecast.getString("day");
      int aHigh = aForecast.getInt("high");
      int aLow = aForecast.getInt("low");
      aText = aForecast.getString("text");

      yWeathers[i+1] = new YWeather(aCode, aDate, aDay, aHigh, aLow, aText, aTemp, true);
    }
  }

  void addYWeatherObject() {
  }
  String getTitle() {
    return title;
  }
  PVector getLatLong() {
    return latLong;
  }
  String getLogoLink() {
    return logoLink;
  }

  String getPubDate() {
    return pubDate;
  }


  //functions for todays weather
  int getTodaysCode() {
    return yWeathers[0].getCode();
  }
  String getTodaysDate() {
    return yWeathers[0].getDate();
  }
  int getTodaysTemp() {
    return yWeathers[0].getTemp();
  }
  String getTodaysText() {
    return yWeathers[0].getText();
  }
  
  
  //functions for forecast weather
  int getForecastCode(int numDaysAhead) {
    return yWeathers[numDaysAhead].getCode();
  }
  String getForecastDate(int numDaysAhead) {
    return yWeathers[numDaysAhead].getDate();
  }
  String getForecastDay(int numDaysAhead) {
    return yWeathers[numDaysAhead].getDay();
  }
  int getForecastHigh(int numDaysAhead) {
    return yWeathers[numDaysAhead].getHigh();
  }
  int getForecastLow(int numDaysAhead) {
    return yWeathers[numDaysAhead].getLow();
  }
  String getForecastText(int numDaysAhead) {
    return yWeathers[numDaysAhead].getText();
  }
}

