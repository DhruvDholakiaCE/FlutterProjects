import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime{
  String location; //location name
  String time; //time for location
  String flag; //for showing day or night
  String url;
  bool isDaytime = true;

  WorldTime({this.location, this.flag, this.url});

  Future<void> getTime() async {
    try {
      Response response = await get(
          'https://worldtimeapi.org/api/timezone/$url');
      Map data = jsonDecode(response.body);

      //getting data properties
      String datetime = data['datetime'];
      String offset = data['utc_offset'];
      String modOffset= offset.substring(1,3);
      //create datetime object
      DateTime now = DateTime.parse(datetime);
      if(offset[0] == '+'){

        now = now.add(Duration(hours: int.parse(modOffset)));
      }
      else{
        print(modOffset);
        now = now.subtract(Duration(hours: int.parse(modOffset)));
      }

      time = DateFormat.jm().format(now); //set the time property
      isDaytime = now.hour > 6 && now.hour < 20? true: false;
      print(now.hour);
    }
    catch(e){
      print(e);
      time = 'Something Went Wrong';
    }
  }
}