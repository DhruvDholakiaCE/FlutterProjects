import 'package:flutter/material.dart';
import 'package:world_time_pp/services/world_time.dart';

class ChooseLocation extends StatefulWidget {
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {

  List<WorldTime> locations = [
    WorldTime(url: 'Europe/London', location: 'London', flag: 'uk.png'),
    WorldTime(url: 'America/Chicago', location: 'Chicago', flag: 'usa.png'),
    WorldTime(url: 'Africa/Cairo', location: 'Cairo', flag: 'africa.png'),
    WorldTime(url: 'Asia/Seoul', location: 'Seoul', flag: 'uk.png'),
    WorldTime(url: 'America/Nairobi', location: 'Nairobi', flag: 'kenya.png'),
    WorldTime(url: 'Asia/Jakarta', location: 'Jakarta', flag: 'indonesia.png'),
    WorldTime(url: 'Europe/Berlin', location: 'Berlin', flag: 'germany.png')
  ];

  void updateTime(index) async {
    WorldTime instance = locations[index];
    await instance.getTime();
    
    Navigator.pop(context, {
      'location': instance.location,
      'time' : instance.time,
      'isDaytime' : instance.isDaytime,
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('After GETDATA');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
            'Choose Location',
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
              child: Card(
                child: ListTile(

                  onTap: (){
                    updateTime(index);
                  },
                  title: Text(locations[index].location),
                  leading: CircleAvatar(

                    backgroundImage: AssetImage('images/${locations[index].flag}'),
                ),
                ),
              ),
            );
          }
      ),

    );
  }
}
