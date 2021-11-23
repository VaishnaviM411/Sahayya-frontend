import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';

final storage = new FlutterSecureStorage();

class NearbyNGOs extends StatefulWidget {
  Map<String, dynamic> entityData = {};

  @override
  _NearbyNGOsState createState() => _NearbyNGOsState();
}

class _NearbyNGOsState extends State<NearbyNGOs> {

  Map<String, dynamic> entityData = {};
  double latitude = 0.0, longitude = 0.0;
  String? token = '', username = '', type = '';

  List<NGOInstance> theNGOs = [];

  void getUserData() async {
    token = await storage.read(key: 'token');
    username = await storage.read(key: 'username');
    type = await storage.read(key: 'type');

    try {
      String theURL = 'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/get-ngos/$username';
      final response = await http.get(Uri.parse(theURL),
          headers: {HttpHeaders.authorizationHeader: token!});

      if (response.statusCode == 200) {
        var resp = jsonDecode(response.body);
        List<dynamic> theArray = resp['data'];
        List<Map<dynamic, dynamic>> allNGOs = [];
        setState(() {
          entityData = resp;
          for(var i=0; i<theArray.length; i++){
            Map<dynamic, dynamic> thread2 = Map<dynamic, dynamic>.from(theArray[i]);
            allNGOs.add(thread2);
            theNGOs.add(NGOInstance(data: thread2));
          }
        });
        return;
      }
      await storage.write(key: 'username', value: null);
      await storage.write(key: 'token', value: null);
      await storage.write(key: 'type', value: null);
      Navigator.pushReplacementNamed(context, '/start');
      return;
    } catch (e) {
      print(e);
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF3E5A81),
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                  child: Text('NGOs around me (${theNGOs.length})', style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold
                  ),),
                )
              ],
            ),
            Column(
              children: theNGOs,
            )
          ],
        ),
      ),
    );
  }
}


class NGOInstance extends StatefulWidget {

  var data = {};
  NGOInstance({required this.data});

  @override
  _NGOInstanceState createState() => _NGOInstanceState();
}

class _NGOInstanceState extends State<NGOInstance> {

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

  String listToString(List<dynamic> lst){
    String val = '';
    for(var i=0; i<lst.length; i++){
      val += lst[i];
      if(i != lst.length-1){
        val += ', ';
      }
    }
    return val;
  }

  @override
  Widget build(BuildContext context) {

    var data = widget.data;

    print(data['sectors'].length);

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
                child: Text('${data['name']}', style: TextStyle(
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
                child: Text('${data['description']}', style: TextStyle(
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
                child: Text('${listToString(data['sectors'])}', style: TextStyle(
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
                child: Text('${data['address']}', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    fontSize: 16
                ),),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text('${data['city']}, ${data['state']}', style: TextStyle(
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
