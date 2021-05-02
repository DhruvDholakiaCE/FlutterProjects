import 'package:flutter/material.dart';
import 'package:world_time_pp/pages/choose_location.dart';
import 'package:world_time_pp/pages/home.dart';
import 'package:world_time_pp/pages/loading.dart';
void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context)=> Loading(),
      '/home': (context)=> Home(),
      '/location':(context)=> ChooseLocation(),
    },
  ));
}


