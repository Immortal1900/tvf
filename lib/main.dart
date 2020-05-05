
import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf/pickfiles/pickdocument.dart';
import 'package:tvf/uploadfiles/uploadimage.dart';
import 'package:video_player/video_player.dart';
import 'pickfiles/pickimage.dart';
import 'package:tvf/pickfiles/pickvideos.dart';
import 'package:tvf/setdata/setdata.dart';
import 'package:tvf/pickfiles/pickvideos.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tvf/multipick.dart';
import 'package:random_string/random_string.dart';
import 'package:tvf/pickfiles/pickimage.dart';

void main(){
  runApp(MaterialApp(
        home: homescreen(),
  ));
}
class homescreen extends StatefulWidget {
  @override
  _homescreenState createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  final  authorcontrol=TextEditingController();
  void initState(){
    new Directory('storage/emulated/0/tvf/').create(recursive: true);
    randomfilenames=randomAlphaNumeric(4);
    flname=File('storage/emulated/0/tvf/$randomfilenames.txt');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("CREATE POST"),
          actions: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.blue)
              ),
              color: Colors.blue[800],
              child: Text("UPLOAD IMAGE"),
              onPressed: (){

                  Navigator.push(context,MaterialPageRoute(builder: (context) => uploadimage()));

              },
            )
          ],

        ),
        body:
        Center(
            child: Padding(padding: EdgeInsets.all(16),
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      Container(

                          height: 50,
                          width: MediaQuery. of(context). size. width,
                          child:Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.blue)
                            ),
                            child:  TextField(

                              decoration: InputDecoration(
                                  hintText: "  TITLE"
                              ),
                              onChanged: (val){
                                settitle(val);
                                print(settitle.post_title);
                              }
                              ,
                            ),
                          )

                      ),
                      SizedBox(height: 8),
                      Container(

                          height: 50,
                          width: MediaQuery. of(context). size. width,
                          child:
                          Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.blue)
                              ),
                            child:  TextField(
                              controller: authorcontrol,

                                decoration: InputDecoration(
                                    hintText: "  AUTHOR NAME"
                                ),
                                onChanged: (val){
                                 setauthor(val);
                                 print(setauthor.author);
                                }

                            ),
                          )
                      ),
                      SizedBox(height: 8),
                      Container(

                          height: 120,
                          width: MediaQuery. of(context). size. width,
                          child:
                          Card(

                            shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                           side: BorderSide(color: Colors.blue)
                            ) ,
                            child:  TextField(
                                maxLines: 10,
                                decoration: InputDecoration(
                                    hintText: "  DESCRIPTION"
                                ),
                                onChanged: (val){
                                  setdesc(val);
                                  print(setdesc.desc);
                                }
                            ),

                          )
                      ),
                      SizedBox(height: 8),
                      Container(
                          height: 160,
                          width: MediaQuery. of(context). size. width,
                          child:Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.blue)
                            ),
                            child:Center(
                                child:selectedimage==null? Text("Image not Attached")
                                    :Container(
                                  padding: EdgeInsets.only(left:10,right:10,bottom:10,top: 10),
                                    child: new GridView.builder(
                                        itemCount: selectedimage.length,
                                        gridDelegate:
                                        new SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                        itemBuilder: (BuildContext context, int index) {
                                          return Container(
                                              child:Image.file(selectedimage[index], fit: BoxFit.contain)
                                          );
                                        }
                                    )
                                )
                            ),

                          )
                      ),
                                    FutureBuilder(builder:( BuildContext context, AsyncSnapshot snapshot){

                                      return Container(
                                          height: 160,
                                          width: MediaQuery. of(context). size. width,
                                          child:Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(18.0),
                                                side: BorderSide(color: Colors.blue)
                                            ),
                                            child:Center(
                                                child:selectedvideo==null? Text("VIDEO is not SELECTED")
                                                    :Container(
                                                    child: new GridView.builder(
                                                        itemCount: selectedvideo.length,
                                                        gridDelegate:
                                                        new SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 3),
                                                        itemBuilder: (BuildContext context, int index) {
                                                          return Container(
                                                            child:vcontroller[index].value.initialized
                                                                ?AspectRatio(
                                                              aspectRatio:vcontroller[index].value.aspectRatio ,
                                                              child: VideoPlayer(vcontroller[index]),
                                                            )
                                                                :Container()
                                                            ,
                                                          );
                                                        }
                                                    )
                                                )
                                            )

                                          )
                                      ) ;
                                    })

                           ],
                  ),
                )
            )



        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.endDocked,

        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 10),
                child:FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => pickimage()));

                  },
                  child: Icon(Icons.image),
                  heroTag: null,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10),
                  child:FloatingActionButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => pickvideo()));
                    },
                    child: Icon(Icons.video_library),
                    heroTag: null,
                  ))

            ],
          ),
        )



      /*RaisedButton(
                child:Text("SELECT IMAGE"),
                onPressed:(){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => pickimage()));
            })*/




    );
  }
}
