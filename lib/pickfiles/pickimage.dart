import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tvf/uploadfiles/uploadimage.dart';

void main(){
  runApp(pickimage());
}
class pickimage extends StatefulWidget {
  @override
  _pickimageState createState() => _pickimageState();
}

List <File> selectedimage;
bool imagepicked=false;
class _pickimageState extends State<pickimage> {
  getimage() async{
    //Navigator.push(context,MaterialPageRoute(builder: (context) => mp()));
    List <File> file = await FilePicker.getMultiFile(type: FileType.custom,allowedExtensions: ['jpg','png','jpeg']);
    print("Your image is $file");
    setState(() {
      selectedimage=file;
      imagepicked=true;
      print("Imagepicked=${true}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Imagepicker"),
        actions: <Widget>[ RaisedButton(
          child: Text("SELECT IMAGE"),
          onPressed: (){
            getimage();
          },
        ),
          RaisedButton(
            child: Text("UPLOAD IMAGE"),
            onPressed: (){
              if(imagepicked){
                Navigator.push(context,MaterialPageRoute(builder: (context) => uploadimage()));
              }
            },
          )
        ],

      ),
      body: Center(
          child:selectedimage==null? Text("Image is not loader")
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
                  child: Icon(Icons.check),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),

                  heroTag: null,
                ),
              ),


            ],
          ),
        )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
