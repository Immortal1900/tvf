import 'dart:async';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf/crud.dart';
import 'package:image/image.dart' ;
import 'package:compressimage/compressimage.dart';
import 'package:tvf/pickfiles/pickimage.dart';
import 'package:tvf/pickfiles/pickvideos.dart';
import 'package:tvf/setdata/setdata.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
import 'package:tvf/main.dart';
bool isloading=false;
File thumbnail;
CrudMethods crudMethods= new CrudMethods();
int position;
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
  String thumburl;
  // ignore: must_call_super
  void initState(){
        uploadimage();
    print("UPLOAD IMAGE CALLED");
  }
  Future writeCounter() async {
    var randomphotoname=randomAlphaNumeric(4);
    thumbnail=File('storage/emulated/0/tvf/$randomphotoname.jpg');
    print("$thumbnail THUMBNAIL LOCATION ");
    thumbnail = await selectedimage[0].copy('storage/emulated/0/tvf/$randomphotoname.jpg');
    setState(() {
      thumbnail;
    });
  }
  Future fetchcount()async {
    await Firestore.instance
        .collection('blogs')
        .document('UID')
        .get()
        .then((DocumentSnapshot ds) {
      position= ds.data['newscount'];
    });
    print("newsCOUNT IS $position");
  }
  Future compressNow() async {
    //_futureImage = ImagePicker.pickImage(source: ImageSource.camera);
    //Source of the image in _futureImage
    await writeCounter();
    print("FILE SIZE BEFORE: " + thumbnail.lengthSync().toString());
    await CompressImage.compress(imageSrc:thumbnail.path, desiredQuality: 50); //desiredQuality ranges from 0 to 100
    print("FILE SIZE  AFTER: " + thumbnail.lengthSync().toString());
    setState(() {
      thumbnail;
    });
  }

  uploadimage() async{
    await compressNow();
    await fetchcount();
    print(selectedimage);
    try{
      setState(() {
        isloading=true;
      });

      // **************************************************UPLOAD IMAGE*********************************************************
        if(selectedimage!=null){
          for(int i=0;i<selectedimage.length;i++){
            print("IMAGE UPLOAD STARTED");
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
        print("CONCAT URL IS $downloadurlarr");
      }
        else{
          print("Image not selected");
        }

      // **************************************************UPLOAD VIDEO*********************************************************
        if(selectedvideo!=null){
          for(int i=0;i<selectedvideo.length;i++){
            print("VIDEO UPLOAD STARTED");
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

        print("CONCAT URL IS $downloadvurlarr");
      }
        else{
          print("Video not selected");
        }

      // **************************************************UPLOAD DESCRIPTION AS TXT*********************************************************
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
      // **************************************************UPLOAD THUBNAIL*********************************************************
      try{
        StorageReference firebasStorageRef=FirebaseStorage.instance.ref().child("blogposts").child("THUMBNAILS")
            .child("${randomAlphaNumeric(9)}.jpg");
        final StorageUploadTask thumbuploadTask=firebasStorageRef.putFile(thumbnail);
        thumburl=await(await thumbuploadTask.onComplete).ref.getDownloadURL();
        print("Storage THUMBNAIL desc URL is $thumburl");
      }
      catch(e){
        print("Error on uploading THUMBNAIL $e");
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
        "thumbnailurl":thumburl,
        "position":position,
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












