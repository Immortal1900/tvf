import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf/crud.dart';
import 'package:tvf/pickfiles/pickimage.dart';
import 'package:tvf/pickfiles/pickvideos.dart';
import 'package:tvf/setdata/setdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:tvf/main.dart';
bool isloading=false;
CrudMethods crudMethods= new CrudMethods();

void main(){
  runApp(uploadimage());
}
class uploadimage extends StatefulWidget {
  @override
  _uploadimageState createState() => _uploadimageState();
}

class _uploadimageState extends State<uploadimage> {
  static String downloadurlarr="";
  String downloadurl;
  static String downloadvurlarr="";
  String downloadvurl;
  String txtdownloadurl;
  // ignore: must_call_super
  void initState(){
    uploadimage();
    print("UPLOAD IMAGE CALLED");
  }

  uploadimage() async{
    print(selectedimage);
    try{
      setState(() {
        isloading=true;
      });
      for(int i=0;i<selectedimage.length;i++){
        print("IMAGE UPLOAD STARTED");
        if(selectedimage!=null){
          print(1);
          StorageReference firebasStorageRef=FirebaseStorage.instance.ref().child("blogposts").child("UID")
              .child("${randomAlphaNumeric(9)}.jpg");
          print(2);
          final StorageUploadTask uploadTask=firebasStorageRef.putFile(selectedimage[i]);
          print(3);
          print("UPLOAD STARTED");
          downloadurl=await(await uploadTask.onComplete).ref.getDownloadURL();
          downloadurlarr=downloadurlarr+" "+downloadurl;
          print(4);
          print("IMAGE UPLOAD FINSIHED");
        }
        else{
          print("Image not selected");
        }

        print("CONCAT URL IS $downloadurlarr");
      }
      for(int i=0;i<selectedvideo.length;i++){
        print("VIDEO UPLOAD STARTED");
        if(selectedvideo!=null){
          print(1);
          StorageReference firebasStorageRef=FirebaseStorage.instance.ref().child("blogposts").child("UID").child("videos")
              .child("${randomAlphaNumeric(9)}.mp4");
          print(2);
          final StorageUploadTask uploadTask=firebasStorageRef.putFile(selectedvideo[i]);
          print(3);
          print("UPLOAD STARTED");
          downloadvurl=await(await uploadTask.onComplete).ref.getDownloadURL();
          downloadvurlarr=downloadvurlarr+" "+downloadvurl;
          print(4);
          print("VIDEO UPLOAD FINISHED");
        }
        else{
          print("Video not selected");
        }
        print("CONCAT URL IS $downloadvurlarr");
      }
      try{
        StorageReference firebasStorageRef=FirebaseStorage.instance.ref().child("blogposts").child("UID")
            .child("${randomAlphaNumeric(9)}.txt");
        final StorageUploadTask txtuploadTask=firebasStorageRef.putFile(flname);
        txtdownloadurl=await(await txtuploadTask.onComplete).ref.getDownloadURL();
        print("Storage TXT desc URL is $txtdownloadurl");
      }
      catch(e){
        print("Error on uploading txt $e");
      }
      print("ALL UPLOAD FINISHED");
      print("Concat URL IS $downloadurlarr");
      Map <String,dynamic> blogmap={
        "title":settitle.post_title,
        "authorname":setauthor.author,
        "desctexturl":txtdownloadurl,
        "description":setdesc.desc,
        "imageurls":downloadurlarr,
       "videourls":downloadvurlarr,
        "position":crudMethods.newscount,
      };


      print("MAP CREATED");
      crudMethods.addData(blogmap).then((result){
        print("FINISHED");
        Navigator.pop(context);
      });
    }
    catch(Error){
      print("ERROR:${Error}");
    }
  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: "appTitle",
      home: Scaffold(
        appBar: AppBar(
          title: Text("text"),
        ),
        body: Center(child:
            isloading != true? Text("SELECT IMAGE"):
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             Text("UPLOADING...."),
             Container(
               width: 100,
               height: 100,

                 child: CircularProgressIndicator(),

             )
            ],
          )


        )
      ),
    );
  }
}












