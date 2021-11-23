import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


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

class ApplyForGiveOut extends StatefulWidget {
  const ApplyForGiveOut({Key? key}) : super(key: key);

  @override
  _ApplyForGiveOutState createState() => _ApplyForGiveOutState();
}

class _ApplyForGiveOutState extends State<ApplyForGiveOut> {

  String? TOKEN='', USERNAME='', TYPE='';
  String title = '', body = '';
  List<File> docs = [];
  List<String> documentsArray = [];

  void getUserData() async {
    TOKEN = await storage.read(key: 'token');
    USERNAME = await storage.read(key: 'username');
    TYPE = await storage.read(key: 'type');
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }




  @override
  Widget build(BuildContext context) {

    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    String id = arguments['id'];

    return Scaffold(
      backgroundColor: Color(0xFF3E5A81),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
                child:RichText(
                  text: TextSpan(children: [
                    TextSpan(text: 'Application for Donor Give-Out',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),)
                  ]),
                ),
              ),
              SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(text: 'Title',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17
                      ),)
                  ]),
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
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(text: 'Description',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17
                      ),)
                  ]),
                ),

              ),
              TextField(
                onChanged: (val) {
                  setState(() {
                    body = val;
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
                child:RichText(
                  text: TextSpan(children: [
                    TextSpan(text: 'Relevant Documents',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17
                      ),)
                  ]),
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
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(text: 'Upload',
                          style: TextStyle(
                              color: Color(0xFF3E5A81),
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),)
                      ]),
                    ),
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

                  if (body.length == 0) {
                    final snackBar = SnackBar(
                      content: Text('Please enter Description'),
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar);
                    return;
                  }

                  if(documentsArray.length == 0){
                    final snackBar = SnackBar(
                      content: Text('No documents added'),
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar);
                    return;
                  }

                  Map<dynamic, dynamic> dataToSend = {
                    "username": USERNAME,
                    "title": title,
                    "body": body,
                    "documents": documentsArray,
                    "requestID": id
                  };

                  final response = await http.post(
                      Uri.parse(
                          'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/apply-to-donation-request'),
                      headers: <String, String>{
                        'Content-Type':
                        'application/json; charset=UTF-8',
                        HttpHeaders.authorizationHeader: '$TOKEN'
                      },
                      body: json.encode(dataToSend));

                  if(response.statusCode == 201){
                    final snackBar = SnackBar(
                      content: Text('Applied Successfully for the donor give-out.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    if(TYPE == 'Company'){
                      Navigator.pushReplacementNamed(context, '/compDonor');
                    }
                    if(TYPE == 'Donor'){
                      Navigator.pushReplacementNamed(context, '/indvDonor');
                    }
                    if(TYPE == 'NGO'){
                      Navigator.pushReplacementNamed(context, '/ngoDashboard');
                    }
                    return;
                  }
                  if(response.statusCode == 403){
                    final snackBar = SnackBar(
                      content: Text('You have already applied for this give-out.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }
                  final snackBar = SnackBar(
                    content: Text('Some error occurred.'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
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
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(text: 'Create Requests',
                            style: TextStyle(
                                color: Color(0xFF3E5A81),

                                fontSize: 20
                            ),)
                        ]),
                      ),

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
