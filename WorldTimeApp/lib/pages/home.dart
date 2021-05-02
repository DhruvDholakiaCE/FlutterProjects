import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  @override
  Widget build(BuildContext context) {


    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;

    String bgImage = data['isDaytime'] ?'images/day.jpg':'images/night.jpg';
    Color editColor = data['isDaytime']? Colors.deepPurple: Colors.white;
    Color otherColor = data['isDaytime']? Colors.black: Colors.amber;


    return Scaffold(
      
      body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bgImage),
                fit: BoxFit.cover
              )
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 200, 30, 0),
              child: Column(

                children: <Widget>[
                  FlatButton.icon(
                      onPressed: () async{
                        dynamic result = await Navigator.pushNamed(context, '/location');
                        setState(() {
                          data = {
                            'location': result['location'],
                            'time': result['time'],
                            'isDaytime': result['isDaytime'],
                          };
                        });
                      },
                      icon: Icon(Icons.edit_location_rounded,
                        color: editColor,
                      ),
                      label: Text('Edit Location',
                        style: TextStyle(
                          color: editColor,
                          letterSpacing: 2.0,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(data['location'],
                      style: TextStyle(
                          color: otherColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 38,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Text(
                          data['time'],
                          style: TextStyle(
                            color: otherColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
      ),
    );
  }
}
