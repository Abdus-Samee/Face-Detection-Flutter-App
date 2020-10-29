import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _isLoading;
  File _image;
  List _output;
  var ans;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    loadModel().then((val){
      setState(() {
        _isLoading = false;
      });
    });
  }

  loadModel() async {
    Tflite.close();

    try{
      await Tflite.loadModel(
        model: 'assets/model_unquant.tflite',
        labels: 'assets/labels.txt',
        numThreads: 1,
      );
    }catch(e){
      print(e);
    }
  }

  chooseImage() async {
    var newImage = await ImagePicker().getImage(source: ImageSource.gallery);
    File image = File(newImage.path);

    print(image);

    if(image == null) return;
    setState(() {
      _isLoading = false;
      _image = image;
    });

    runModelOnImage(image);
  }

  runModelOnImage(File image) async {
    print("Entered runMOdel");

    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0.5,
      asynch: true,
    );

    print(output[0]['label']);

    setState(() {
      _isLoading = false;
      _output = output;
      ans = output[0]['label'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ML with Flutter',
        ),
      ),
      body: _isLoading ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ) : Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null ? Container() : Image.file(_image),
            SizedBox(height: 16,),
            _output == null ? Text("No output") : Text("$ans"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          chooseImage();
        },
        child: Icon(Icons.image),
      ),
    );
  }
}
