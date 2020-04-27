
import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf/uploadfiles/uploadimage.dart';
import 'pickfiles/pickimage.dart';
import 'package:tvf/pickfiles/pickvideos.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tvf/multipick.dart';
import 'package:random_string/random_string.dart';
import 'package:tvf/pickfiles/pickimage.dart';


String  post_title="";
String  author_name="";
String  description="";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("CREATE POST"),
        actions: <Widget>[
          RaisedButton(
            color: Colors.teal,
            child: Text("UPLOAD IMAGE"),
            onPressed: (){
              if(imagepicked){
                Navigator.push(context,MaterialPageRoute(builder: (context) => uploadimage()));
              }
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
                      color: Colors.teal,
                      height: 50,
                      width: MediaQuery. of(context). size. width,
                      child:Card(
                        child:  TextField(
                          decoration: InputDecoration(
                              hintText: "  TITLE"
                          ),
                          onChanged: (val){
                            post_title=val;
                            print(post_title);
                          }
                          ,
                        ),
                      )

                  ),
                  SizedBox(height: 8),
                  Container(
                      color: Colors.teal,
                      height: 50,
                      width: MediaQuery. of(context). size. width,
                      child:
                      Card(
                        child:  TextField(
                        decoration: InputDecoration(
                            hintText: "  AUTHOR NAME"
                        ),
                            onChanged: (val){
                             author_name=val;
                             print(author_name);
                            }
                  ),
          )
                  ),
                  SizedBox(height: 8),
                  Container(
                      color: Colors.teal,
                      height: 120,
                      width: MediaQuery. of(context). size. width,
                      child:
                      Card(
                        child:  TextField(
                          maxLines: 10,
                          decoration: InputDecoration(
                              hintText: "  DESCRIPTION"
                          ),
                            onChanged: (val){
                            description=val;
                            print(description);
                            }
                          ),

                         )
                        ),
                  SizedBox(height: 8),
                  Container(
                      color: Colors.teal,
                      height: 160,
                      width: MediaQuery. of(context). size. width,
                      child:Card(
                        child: Row(
                          children: <Widget>[
                            Center(
                                child:selectedimage==null? Text("Image not Attached")
                                    :Container(
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
                            Center(
                                child:selectedvideo==null? Text("Video not Attached")
                                    :Container(
                                    child: new GridView.builder(
                                        itemCount: selectedvideo.length,
                                        gridDelegate:
                                        new SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                        itemBuilder: (BuildContext context, int index) {
                                          return Container(
                                              child:Text(selectedvideo[index].toString())
                                          );
                                        }
                                    )
                                )
                            ),

                          ],
                        )
                      )
                  )
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
