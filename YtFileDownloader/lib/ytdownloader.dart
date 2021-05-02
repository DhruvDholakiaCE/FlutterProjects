
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui';
import 'package:web_scraper/web_scraper.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';



class YTDownloader extends StatefulWidget {
  @override
  _YTDownloaderState createState() => _YTDownloaderState();
}

class _YTDownloaderState extends State<YTDownloader> {
  Directory _downloadsDirectory;
  int progress = 0;
  TextEditingController urlController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDownloadsDirectoryState();

    print('inside InitState');

  }

  Future<void> initDownloadsDirectoryState() async {
    Directory downloadsDirectory;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    } on PlatformException {
      print('Could not get the downloads directory');
    }
    if (!mounted) return;
    setState(() {
      _downloadsDirectory = downloadsDirectory;
    });
  }


  String url ='';
  String filename = '';
  String loading = 'none';
  Map finalMusicData = {};
  List musicData = [];
  List videoData = [];
  NetworkImage thumbnail;
  bool music = true;
  Color musicButtonTextColor = Colors.white;
  Color videoButtonTextColor = Colors.white38;
  Color buttonSelectedColor = Colors.white;
  Color buttonDeselectedColor = Colors.white38;

  Future initChaptersTitleScrap(String urlId) async{
    setState(() {
      FocusScope.of(context).unfocus();
      loading = 'showHour';
    });
    final webScraper = WebScraper('https://www.yt-download.org');

    //Processing Audio Data
    if(await  webScraper.loadWebPage('/api/button/mp3/$urlId')){
      print('URL ID : $urlId');
      List tags = ['type','bitRate', 'size'];
      print('it is working');
      var content =  webScraper.getElement('body > div > div > div > div > a ', ['href', 'title']);
      print(content);
      for(int i = 0 ; i< content.length; i++){

        List<String> rawInfo = content[i]['title'].split('\n');

        for(int i = 0 ; i < rawInfo.length; i ++ ){
          rawInfo[i] = rawInfo[i].trim();
        }
        print(rawInfo);
        int index = 0;
        Map temp = {};
        print(rawInfo.length);

        for(int j = 0; j< rawInfo.length; j++ ){
          if(rawInfo[j].isNotEmpty){
              temp[tags[index]] = rawInfo[j];
              index+=1;
          }
        }
        temp['link'] = content[i]['attributes']['href'];
        musicData.add(temp);

      }
      print('THIS IS THE MUSIC DATA');
      print(musicData);
    }

    //Processing Video Data
    if(await  webScraper.loadWebPage('/api/button/videos/$urlId')){

      List tags = ['type','resolution', 'size'];

      var content =  webScraper.getElement('body > div > div > div > div > a ', ['href', 'title']);
      print(content);
      for(int i = 0 ; i< content.length; i++){

        List<String> rawInfo = content[i]['title'].split('\n');
        for(int i = 0 ; i < rawInfo.length; i ++ ){
          rawInfo[i] = rawInfo[i].trim();
        }
        int index = 0;
        Map temp = {};
        for(int j = 0; j< rawInfo.length; j++ ){
          if(rawInfo[j].isNotEmpty){
            temp[tags[index]] = rawInfo[j];
            index+=1;
          }
        }
        temp['link'] = content[i]['attributes']['href'];
        videoData.add(temp);
      }
      print(videoData);
    }

    //extracting video title from Youtube
    WebScraper webScraper2 = WebScraper('https://www.youtube.com');
    if(await webScraper2.loadWebPage('/get_video_info?video_id=$urlId')){
      String content = webScraper2.getPageContent();
      RegExp exp = new RegExp(r'title.*');
      List<String> cn = exp.allMatches(Uri.decodeFull(content)).first.group(0).split(':');
      print(cn[1].split(',')[0].replaceAll('"', '').replaceAll('+', ' '));
      filename = cn[1].split(',')[0].replaceAll('"', '').replaceAll('+', ' ');

    }
    thumbnail =  NetworkImage('https://i.ytimg.com/vi/$urlId/0.jpg');
    setState(() {
      loading = 'showData';
    });

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: false,

        appBar: AppBar(
          title: Text('Youtube Media Downloader', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1, fontSize: 21),),
          centerTitle: true,
        ),

        body: Container(

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  controller: urlController,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: (){
                            setState(() {
                              urlController.text = '';
                              loading = 'none';
                            });
                          },
                        child: Icon(Icons.clear, color: Color(0xff3081f9), size: 27, )
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      borderSide: const BorderSide(color: Colors.amber, width: 2.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      borderSide: const BorderSide(color: Color(0xff3081f9), width: 2.0),
                    ),
                  ),
                ),
              ),

              RaisedButton(
                elevation: 5,
                splashColor: Colors.amber,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                onPressed: () async{
                    String urlId = urlController.text.split('/').last;
                    url ='';
                    filename = '';
                    loading = 'none';
                    finalMusicData = {};
                    musicData = [];
                    videoData = [];
                    await initChaptersTitleScrap(urlId);
                  },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text(
                      'Convert',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                color: Color(0xff3a3885),
              ),
              // SizedBox(height: 10,),
              loading == 'none' ? Container() : loading == 'showHour' ? Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 100.0, 10.0, 0.0),
                child: SpinKitPouringHourglass(
                  color: Colors.amber,
                  size: 70.0,
                ),
              ):
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
                child: Container(

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Divider(height: 30, thickness: 5, color: Colors.black54,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Image(

                              image: thumbnail,
                            ),
                          ),
                          SizedBox(width: 7,),
                          Flexible(
                              flex: 1,
                              child: Text(
                                filename, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 5,),
                      Divider(height: 30, thickness: 5, color: Colors.black54,),
                      Row(
                        children: [
                          SizedBox(width: 5,),
                          Container(
                              height: 35,
                              child: FlatButton(
                                  splashColor: Colors.amber,
                                  onPressed: (){setState(() { music = true; musicButtonTextColor = buttonSelectedColor; videoButtonTextColor = buttonDeselectedColor; });},
                                  child: Text('Music', style: TextStyle(fontSize: 17, color: musicButtonTextColor),), color: Color(0xff3a3885),)
                                ),

                          SizedBox(width: 5,),
                          Container(
                              height: 35,
                              child: FlatButton(
                                  splashColor: Colors.amber,
                                  onPressed: (){setState(() { music = false; videoButtonTextColor = buttonSelectedColor; musicButtonTextColor = buttonDeselectedColor; });},
                                  child: Text('Video', style: TextStyle(fontSize: 17, color: videoButtonTextColor)), color: Color(0xff3a3885))
                              ),
                        ],
                      ),
                      SizedBox(height: 3,),
                      music ? musicTable(musicData, _downloadsDirectory.path):
                      videoTable(videoData, _downloadsDirectory.path),
                      music ? Divider(height: 40, thickness: 5, color: Colors.black54,) : Divider(height: 188, thickness: 5, color: Colors.black54,),
                    ],
                  ),

                ),
              ),

            ],
          ),
        )
    );
  }
}

//Row for music or video table
TableRow customRow(data, downloadPath, music){
  return TableRow(
      children: [
        Container(

          height: 37,
          width: double.infinity,
          child: Card(
            elevation: 5,
            color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Text(data['type'].toUpperCase(), textScaleFactor: 1.1,style: TextStyle(fontWeight: FontWeight.w400),),

                Text(music ? data['bitRate']: data['resolution'] , textScaleFactor: 1.1, style: TextStyle(fontWeight: FontWeight.w400),),

                Text(data['size'], textScaleFactor: 1.1, style: TextStyle(fontWeight: FontWeight.w400),),

                GestureDetector(
                    onTap: () async{
                      final status= await Permission.storage.request();
                      if(status.isGranted){
                        final id = await FlutterDownloader.enqueue(
                          url: data['link'],
                          headers: {"auth": "test_for_sql_encoding"},
                          savedDir: downloadPath,
                          // fileName: ,
                          showNotification: true,
                          openFileFromNotification: true,
                        );
                      }
                    },
                    child: Icon(Icons.download_outlined, size: 27,)
                ),

              ],
            ),
          ),
        ),
      ]
  );

}

//Music contents showing
Table musicTable(musicData, downloadPath){
  return Table(
    children: validData(musicData, downloadPath, true),
  );
}

//function to get proper data as received amount
List<TableRow> validData(data, downloadPath, music){
  List<TableRow> rows= [];
  rows.add(music ? TableRow(
      children: [
        Container(

          height: 40,
          width: double.infinity ,
          child: Card(
            elevation: 5,
            color: Colors.lightBlue,
            child: Row(

              children: [
                SizedBox(width: 20,),
                Text('Type', textScaleFactor: 1.19, style: TextStyle(fontWeight: FontWeight.w500),),
                SizedBox(width: 40,),
                Text('Bit Rate', textScaleFactor: 1.19, style: TextStyle(fontWeight: FontWeight.w500),),
                SizedBox(width: 60,),
                Text('Size', textScaleFactor: 1.19, style: TextStyle(fontWeight: FontWeight.w500),),
                SizedBox(width: 32,),
                Text('Download', textScaleFactor: 1.15, style: TextStyle(fontWeight: FontWeight.w500),),

              ],
            ),
          ),
        ),
      ]
  ): TableRow(
      children: [
        Container(
          height: 40,
          width: double.infinity ,
          child: Card(
            elevation: 5,
            color: Colors.lightBlue,
            child: Row(

              children: [
                SizedBox(width: 20,),
                Text('Type', textScaleFactor: 1.19, style: TextStyle(fontWeight: FontWeight.w500),),
                SizedBox(width: 30,),
                Text('Resolution', textScaleFactor: 1.19, style: TextStyle(fontWeight: FontWeight.w500),),
                SizedBox(width: 40,),
                Text('Size', textScaleFactor: 1.19, style: TextStyle(fontWeight: FontWeight.w500),),
                SizedBox(width: 40,),
                Text('Download', textScaleFactor: 1.15, style: TextStyle(fontWeight: FontWeight.w500),),

              ],
            ),
          ),
        ),
      ]
  ));
  for(int i = 0 ; i< data.length; i++){
    rows.add(customRow(data[i], downloadPath, music));
  }
  return rows;
}

//video Contents showing
Table videoTable(videoData, downloadPath){
  return Table(
    children: validData(videoData, downloadPath, false),
  );
}
