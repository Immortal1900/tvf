import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf/crud.dart';
import 'package:tvf/pickfiles/pickimage.dart';
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
  // ignore: must_call_super
  void initState(){
    uploadimage();
  }



  uploadimage() async{

    try{
      setState(() {
        isloading=true;
      });

      for(int i=0;i<selectedimage.length;i++){
        if(selectedimage!=null){
          print(1);
          StorageReference firebasStorageRef=FirebaseStorage.instance.ref().child("blogposts")
              .child("${randomAlphaNumeric(9)}.jpg");
          print(2);
          final StorageUploadTask uploadTask=firebasStorageRef.putFile(selectedimage[i]);
          print(3);
          print("UPLOAD STARTED");
          downloadurl=await(await uploadTask.onComplete).ref.getDownloadURL();
          downloadurlarr=downloadurlarr+" "+downloadurl;
          print(4);
        }
        else{
          print("Image not selected");
        }
      }
      print("Concat URL IS $downloadurlarr");
      Map <String,String> blogmap={
        "title":post_title,
        "authorname":author_name,
        "description":description,
        "url":downloadurlarr,
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
           Container(
             height: 100,
             width: 100,
             child:  Card(
               child: CircularProgressIndicator(),
             ),
           )


        )
      ),
    );
  }
}












