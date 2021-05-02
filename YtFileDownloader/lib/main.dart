
import 'package:filedownloader/ytdownloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // home: MyHomePage(),
    home: YTDownloader(),
  ));
}

