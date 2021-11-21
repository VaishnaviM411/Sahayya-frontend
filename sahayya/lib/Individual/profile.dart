import 'package:flutter/material.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sahayya/NGO/editProfile.dart';
import 'dart:io';
import 'dart:convert';
import 'package:sahayya/NGO/components/textNonEdit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class Profile extends StatefulWidget {
  Map<String, dynamic> entityData = {
    "isVerified": false,
    "name": "",
    "email": "",
    "address": "",
    "regNo": "",
    "state": "",
    "sectors": [
      ""
    ],
    "coOrdinates": {
      "longitude": 73.81396316384317,
      "latitude": 18.63063063063063
    },
    "city": "",
    "picture": "",
    "description": "",
    "username": "",
    "type": ""
  };

  Profile({required this.entityData});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  File? _image;
  double latitude = 0.0, longitude = 0.0;
  String? token='', username='', type='';

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
    print(widget.entityData['picture']);
    File tempo = await urlToFile(widget.entityData['picture']);
    setState(() {
      _image = tempo;
    });
  }

  void getStorageValues() async {
    token = await storage.read(key: 'token');
    username = await storage.read(key: 'username');
    type = await storage.read(key: 'type');
  }

  void getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      latitude = position.latitude;
      longitude = position.longitude;
      print(position);
    } catch (e) {
      print(e);
    }
  }


  @override
  void initState() {
    super.initState();
    setImage();
    getCurrentLocation();
    getStorageValues();
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

  Widget verifiedRegNo(Map<String, dynamic> entityData){
    if(entityData['isVerified']){
      return (
          TextNonEdit(label: 'State', text: '${widget.entityData['state']}')
      );
    }
    return SizedBox(height: 0,);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF3E5A81),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Container(
          color: Color.fromRGBO(255, 255, 255, 0.03),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(CircleBorder()),
                          ),
                        child: Icon(Icons.my_location, color: Color(0xFF3E5A81),),
                        onPressed: () async {
                          Map<String, dynamic> theData = {
                            "coOrdinates": {
                              "latitude": latitude,
                              "longitude": longitude
                            }};

                          JsonEncoder encoder = JsonEncoder();
                          final dynamic object = encoder.convert(theData);
                          final response = await http.put(
                              Uri.parse(
                                  'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/profile/$username'),
                              headers: <String, String>{
                                'Content-Type':
                                'application/json; charset=UTF-8',
                                HttpHeaders.authorizationHeader: token!,
                              },
                              body: object);

                          if(response.statusCode == 200){
                            final snackBar = SnackBar(
                              content: Text('Profile Updated Successfully'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            Navigator.pushReplacementNamed(context, '/ngoDashboard');
                            return;
                          }
                          else{
                            final snackBar = SnackBar(
                              content: Text('Some error occurred.'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            return;
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Color(0xFFFFFFFF), width: 2.0)))),
                          child: Text('Edit', style: TextStyle(color: Color(0xFF3E5A81))),
                          onPressed: () {
                            Navigator.pushNamed(context, '/editNGOProfile');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
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
                SizedBox(
                  height: 20,
                ),
                TextNonEdit(label: 'Username', text: '${widget.entityData['username']}'),
                SizedBox(
                  height: 20,
                ),
                TextNonEdit(label: 'Name', text: '${widget.entityData['name']}'),
                SizedBox(
                  height: 20,
                ),
                TextNonEdit(label: 'Email', text: '${widget.entityData['email']}'),
                SizedBox(
                  height: 20,
                ),
                TextNonEdit(label: 'Description', text: '${widget.entityData['description']}'),
                SizedBox(
                  height: 20,
                ),
                TextNonEdit(label: 'Address', text: '${widget.entityData['address']}'),
                SizedBox(
                  height: 20,
                ),
                TextNonEdit(label: 'City', text: '${widget.entityData['city']}'),
                SizedBox(
                  height: 20,
                ),
                TextNonEdit(label: 'State', text: '${widget.entityData['state']}'),
                SizedBox(
                  height: 20,
                ),
                TextNonEdit(label: 'Sectors', text: '${listToString(widget.entityData['sectors'])}'),
                SizedBox(
                  height: 20,
                ),
                TextNonEdit(label: 'Verified?', text: '${widget.entityData['isVerified'] ? 'Yes' : 'No'}'),
                SizedBox(
                  height: 20,
                ),
                verifiedRegNo(widget.entityData),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Color(0xFFFFFFFF), width: 2.0)))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          child: Text('Logout', style: TextStyle(color: Color(0xFF3E5A81), fontSize: 20)),
                        ),
                        onPressed: () async {
                          await storage.write(key: 'username', value: null);
                          await storage.write(key: 'token', value: null);
                          await storage.write(key: 'type', value: null);
                          Navigator.pushReplacementNamed(context, '/start');
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
