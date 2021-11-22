import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:date_field/date_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';

final storage = new FlutterSecureStorage();

border(BuildContext context) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30.0),
    ),
    borderSide: BorderSide(
      color: Colors.white,
      width: 0.0,
    ),
  );
}

focusBorder(BuildContext context) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30.0),
    ),
    borderSide: BorderSide(
      color: Color(0xFFe0fcfb),
      width: 1.0,
    ),
  );
}

class CreateGiveOut extends StatefulWidget {
  const CreateGiveOut({Key? key}) : super(key: key);

  @override
  _CreateGiveOutState createState() => _CreateGiveOutState();
}

class _CreateGiveOutState extends State<CreateGiveOut> {
  String title = '', description = '', requirements='';
  DateTime? selectedDate;
  List<File> docs = [];
  List<String> documentsArray = [];
  double latitude = 0.0, longitude = 0.0;
  String? TOKEN='', USERNAME='', TYPE='';

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

  void getUserData() async {
    TOKEN = await storage.read(key: 'token');
    USERNAME = await storage.read(key: 'username');
    TYPE = await storage.read(key: 'type');
  }

  List<String> stringToList(String s){
    List<String> s1 = s.split(', ');
    List<String> s2 = [];
    for(var i=0; i<s1.length; i++){
      s2.add(s1[i].trim());
    }
    return s2;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3E5A81),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
                child: Text(
                  'NGO Request',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
                enabled: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF3E5A81),
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: border(context),
                  enabledBorder: border(context),
                  focusedBorder: focusBorder(context),
                  hintText: 'Title for your request',
                ),
                textInputAction: TextInputAction.next,
                onChanged: (val) {
                  setState(() {
                    title = val;
                  });
                },
              ),
              SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                child: Text(
                  'Description',
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                onChanged: (val) {
                  setState(() {
                    description = val;
                  });
                },
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Describe your request",
                  filled: true,
                  fillColor: Color(0xFF3E5A81),
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: border(context),
                  enabledBorder: border(context),
                  focusedBorder: focusBorder(context),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                child: Text(
                  'Requirements',
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                onChanged: (val) {
                  setState(() {
                    requirements = val;
                  });
                },
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Add available material seperated by commas (,)",
                  filled: true,
                  fillColor: Color(0xFF3E5A81),
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: border(context),
                  enabledBorder: border(context),
                  focusedBorder: focusBorder(context),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                child: Text(
                  'Apply By Date',
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              DateTimeField(
                  decoration: const InputDecoration(
                    hintText: 'Enter your deadline to apply',
                    filled: true,
                    fillColor: Color(0xFF3E5A81),
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    focusColor: Colors.white,
                  ),
                  selectedDate: selectedDate,
                  onDateSelected: (DateTime value) {
                    setState(() {
                      selectedDate = value;
                    });
                  }),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                child: Text(
                  'Relevant Documents',
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Color(0xFFFFFFFF), width: 2.0)))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    child: Text('Upload', style: TextStyle(color: Color(0xFF3E5A81), fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (result != null) {
                      List<File> files = result.paths.map((path) => File(path!)).toList();
                      setState(() {
                        docs = files;
                      });

                      for(var i=0; i<docs.length; i++){
                        var postUri = Uri.parse(
                            "https://asia-south1-sahayya-9c930.cloudfunctions.net/api/upload-file");
                        var request = new http.MultipartRequest("POST", postUri);
                        request.files
                            .add(await http.MultipartFile.fromPath('file', docs[i].path));
                        request.send().then((result) async {
                          http.Response.fromStream(result).then((response) async {
                            var body = json.decode(response.body);
                            print(body['link']);
                            setState(() {
                              documentsArray.add(body['link']);
                            });
                          });
                        });
                      }

                    } else {
                      final snackBar = SnackBar(
                        content: Text('Files not selected. Please try again.'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (title.length == 0) {
                    final snackBar = SnackBar(
                      content: Text('Please enter Title'),
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar);
                    return;
                  }

                  if (description.length == 0) {
                    final snackBar = SnackBar(
                      content: Text('Please enter Description'),
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar);
                    return;
                  }

                  if (requirements.length == 0) {
                    final snackBar = SnackBar(
                      content: Text('Please enter Requirements'),
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar);
                    return;
                  }

                  if(selectedDate == null){
                    final snackBar = SnackBar(
                      content: Text('Please select Apply Date'),
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar);
                    return;
                  }

                  List<String> formattingDate = selectedDate.toString().split(" ")[0].split("-");


                  Map<dynamic, dynamic> dataToSend = {
                    "username": USERNAME,
                    "title": title,
                    "description": description,
                    "available-material": stringToList(requirements),
                    "applyBy": '${formattingDate[2]}-${formattingDate[1]}-${formattingDate[0]}',
                    "coOrdinates": {
                      "latitude": latitude,
                      "longitude": longitude
                    },
                    "documentsArray": documentsArray
                  };

                  final response = await http.post(
                      Uri.parse(
                          'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/give-out-donation'),
                      headers: <String, String>{
                        'Content-Type':
                        'application/json; charset=UTF-8',
                        HttpHeaders.authorizationHeader: '$TOKEN'
                      },
                      body: json.encode(dataToSend));

                  if(response.statusCode == 201){
                    final snackBar = SnackBar(
                      content: Text('Application Created Successfully'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    if(TYPE == 'Company'){
                      Navigator.pushReplacementNamed(context, '/compDonor');
                    }
                    if(TYPE == 'Donor'){
                      Navigator.pushReplacementNamed(context, '/indvDonor');
                    }

                    return;
                  }

                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Color(0xFFFFFFFF), width: 2.0)))),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text('Create Request', style: TextStyle(color: Color(0xFF3E5A81), fontSize: 20)),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
