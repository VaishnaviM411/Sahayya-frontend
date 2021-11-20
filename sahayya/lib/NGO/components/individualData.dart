import 'package:flutter/material.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class IndividualData extends StatefulWidget {

  Map<dynamic, dynamic> data = {};
  IndividualData({required this.data});

  @override
  _IndividualDataState createState() => _IndividualDataState();
}

class _IndividualDataState extends State<IndividualData> {

  File? _image;

  Future<File> urlToFile(String imageUrl) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  void setImage() async {
    print(widget.data['picture']);
    File tempo = await urlToFile(widget.data['picture']);
    setState(() {
      _image = tempo;
    });
  }


  @override
  void initState() {
    super.initState();
    setImage();
  }

  @override
  Widget build(BuildContext context) {

    Map<dynamic, dynamic> data = widget.data;



    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),),
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 65,
                child: ClipOval(
                  child: (_image != null)
                      ? Image.file(
                    _image!,
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text('${data['fName']} ${data['lName']}', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 30
                ),),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text('${data['bio']}', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20
                ),),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text('${data['username']}', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    fontSize: 16
                ),),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text('${data['email']}', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    fontSize: 16
                ),),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text('${data['location']}', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    fontSize: 16
                ),),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}



