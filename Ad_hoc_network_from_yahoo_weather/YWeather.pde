class YWeather{
  //example contents code="32" date="13 Jul 2013" day="Sat" high="84" low="68" text="Sunny"
  int code;
  String date;
  String day;
  int high;
  int low;
  String text;
  int temp;
  boolean isForecast;
  YWeather(int _code,String _date,String _day,int _high, int _low, String _text, int _temp, boolean _isForecast){
    code=_code;
    date=_date;
    day =_day;
    high=_high;
    low=_low;
    text=_text;
    temp=_temp;
    isForecast = _isForecast;
  }
  int getCode(){
   return code; 
  }
  String getDate(){
   return date; 
  }
  String getDay(){
    return day;
  }
  int getHigh(){
   return high; 
  }
  int getLow(){
   return low; 
  }
  String getText(){
   return text; 
  }
  int getTemp(){
    return temp;
  }
  
  
  
}
