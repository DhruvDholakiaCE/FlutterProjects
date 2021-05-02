import 'package:flutter/material.dart';
import 'package:world_time_pp/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {


  void setupWorlTime() async{
    WorldTime instance = WorldTime(location: 'Berlin', flag:'germany.png', url: 'Europe/Berlin');
    await instance.getTime();
    Navigator.pushNamed(context, '/home', arguments: {
      'location': instance.location,
      'time' : instance.time,
      'isDaytime' : instance.isDaytime,
    });
    print(instance.isDaytime);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupWorlTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitPouringHourglass(
            color: Colors.amber,
            size: 100.0,

          ),
          SizedBox(height: 23,),
          Text(
            'Patience is a Key to Success!',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 20,
            ),
          ),
        ],
      ),
      
      backgroundColor: Colors.blue,
    );
  }
}
