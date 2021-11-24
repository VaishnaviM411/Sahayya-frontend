import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';
import '../utils/sectors.dart';
import '../sectorInstance.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class EditCompanyProfile extends StatefulWidget {
  const EditCompanyProfile({Key? key}) : super(key: key);

  @override
  _EditCompanyProfileState createState() => _EditCompanyProfileState();
}

class _EditCompanyProfileState extends State<EditCompanyProfile> {
  String username = '',
      email = '',
      name = '',
      contactNo = '',
      address = '',
      description = '',
      password = '',
      imageURL =
          'https://firebasestorage.googleapis.com/v0/b/bizrep-b0184.appspot.com/o/profile_picture.png?alt=media&token=f23c3431-328e-47d6-8e0c-a1dfabbf13bf';

  double latitude = 0.0, longitude = 0.0;

  String type = '';

  List<String> selectedSectors = [];

  List<String> allTheSectors = industrySectors;

  List<SectorInstance> selectedSectorInstances = [];

  String? _chosenSector;

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

  //File _image = File('images/giftbox.png');
  File? _image;
  late String url;

  String profilePic =
      'https://booleanstrings.com/wp-content/uploads/2021/10/profile-picture-circle-hd.png';

  Future<File> urlToFile(String imageUrl) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

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

  void setImage() async {
    File tempo = await urlToFile(profilePic);
    setState(() {
      _image = tempo;
    });
  }

  Map<String, dynamic> entityData = {};
  String? TOKEN = '', USERNAME = '', TYPE = '';

  void getStorageValues() async {
    TOKEN = await storage.read(key: 'token');
    USERNAME = await storage.read(key: 'username');
    TYPE = await storage.read(key: 'type');
  }

  void getUserData() async {
    TOKEN = await storage.read(key: 'token');
    USERNAME = await storage.read(key: 'username');
    TYPE = await storage.read(key: 'type');

    String theURL =
        'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/profile/' +
            USERNAME!;
    final response = await http.get(Uri.parse(theURL),
        headers: {HttpHeaders.authorizationHeader: TOKEN!});

    if (response.statusCode == 200) {
      print(response.statusCode);
      Map<String, dynamic> resp = jsonDecode(response.body);
      setState(() {
        entityData = resp;
        name = resp['name'];
        email = resp['email'];
        description = resp['description'];
        address = resp['address'];
        contactNo = resp['contactNo'];
        profilePic = resp['picture'];
        setImage();
      });
      return;
    }
    await storage.write(key: 'username', value: null);
    await storage.write(key: 'token', value: null);
    await storage.write(key: 'type', value: null);
    return;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    setImage();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (username == null) {
      Navigator.pushReplacementNamed(context, '/start');
    }

    Future<void> uploadPic(BuildContext context) async {
      if (_image == null) {
        setState(() {
          imageURL = "";
        });
      } else {
        var postUri = Uri.parse(
            "https://asia-south1-sahayya-9c930.cloudfunctions.net/api/upload-file");
        var request = new http.MultipartRequest("POST", postUri);
        request.files
            .add(await http.MultipartFile.fromPath('file', _image!.path));
        request.send().then((result) async {
          http.Response.fromStream(result).then((response) async {
            var body = json.decode(response.body);
            print(body['link']);
            setState(() {
              imageURL = body['link'];
            });
          });
        });
        setState(() {
          imageURL = "";
        });
      }
    }

    Future getImage() async {
      PickedFile? image =
          await ImagePicker().getImage(source: ImageSource.gallery);
      setState(() {
        _image = File(image!.path);
      });
      setState(() async {
        await uploadPic(context);
      });
    }

    int myTrigger = 3;

    void deleteSectorInstance(String value) {
      // print(value);
      // setState(() {
      //   allTheSectors.add(value);
      //   selectedSectors.remove(value);
      //   selectedSectorInstances.remove(SectorInstance(value, deleteSectorInstance));
      //   myTrigger = 25;
      // });
      // print(allTheSectors);
      // print(selectedSectors);
      // print("Hey Angel");
    }

    return (Scaffold(
      backgroundColor: Color(0xFF3E5A81),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(height: 10.0),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Edit Profile',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23),
                )
              ]),
            ),
            SizedBox(
              height: 35,
            ),
            GestureDetector(
              onTap: () async {
                await getImage();
              },
              child: CircleAvatar(
                radius: 70,
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
            ),
            SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Name',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  )
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
                hintText: '$name',
              ),
              textInputAction: TextInputAction.next,
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
            SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Email',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  )
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
                hintText: '$email',
              ),
              textInputAction: TextInputAction.next,
              onChanged: (val) {
                setState(() {
                  email = val;
                });
              },
            ),
            SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Description',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  )
                ]),
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
                hintText: "$description",
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
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Address',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  )
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
                hintText: '$address',
              ),
              textInputAction: TextInputAction.next,
              onChanged: (val) {
                setState(() {
                  address = val;
                });
              },
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Contact No',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  )
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
                hintText: '$contactNo',
              ),
              textInputAction: TextInputAction.next,
              onChanged: (val) {
                setState(() {
                  contactNo = val;
                });
              },
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Password',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  )
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
                hintText: 'Enter New Password',
                filled: true,
                fillColor: Color(0xFF3E5A81),
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                border: border(context),
                enabledBorder: border(context),
                focusedBorder: focusBorder(context),
              ),
              textInputAction: TextInputAction.next,
              onChanged: (val) {
                setState(() {
                  password = val;
                });
              },
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 45.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Color(0xFF3E5A81),
                boxShadow: [
                  BoxShadow(color: Colors.white70, spreadRadius: 1),
                ],
              ),
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _chosenSector,
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Color(0xFF3E5A81),
                  underline: Container(
                    height: 2,
                    color: Colors.transparent,
                  ),
                  iconSize: 50.0,
                  iconEnabledColor: Colors.white70,
                  isExpanded: true,
                  items: allTheSectors
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    "    Sectors",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      myTrigger = 24;
                      allTheSectors.remove(value);
                      selectedSectors.add(value!);
                      selectedSectorInstances
                          .add(SectorInstance(value, deleteSectorInstance));
                      _chosenSector = allTheSectors[0];
                    });
                  },
                ),
              ),
            ),
            Column(
              children: selectedSectorInstances,
            ),
            SizedBox(
              height: 65,
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  type = 'Donor';
                });
                if (name.length == 0) {
                  final snackBar = SnackBar(
                    content: Text('Please enter Name'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                if (email.length == 0) {
                  final snackBar = SnackBar(
                    content: Text('Please enter a email'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }

                if (contactNo.length == 0) {
                  final snackBar = SnackBar(
                    content: Text('Please enter Contact No'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }

                if (password.length == 0) {
                  final snackBar = SnackBar(
                    content: Text('Please enter Password '),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                if (address.length == 0) {
                  final snackBar = SnackBar(
                    content: Text('Please enter address. '),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                if (description.length == 0) {
                  final snackBar = SnackBar(
                    content: Text('Please enter description'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }
                if (selectedSectors.isEmpty) {
                  final snackBar = SnackBar(
                    content: Text('Please select a sector. '),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }

                Map<String, dynamic> theData = {
                  "email": email,
                  "picture": imageURL,
                  "name": name,
                  "contactNo": contactNo,
                  "address": address,
                  "sectors": selectedSectors,
                  "description": description,
                  "password": password
                };

                print(theData);

                final response = await http.put(
                    Uri.parse(
                        'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/profile/$USERNAME'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      HttpHeaders.authorizationHeader: '$TOKEN'
                    },
                    body: json.encode(theData));

                print(response.statusCode);
                print(response.body);

                if (response.statusCode == 200) {
                  final snackBar = SnackBar(
                    content: Text('Profile updated successfully'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.pushReplacementNamed(context, '/compDonor');
                  return;
                }
                final snackBar = SnackBar(
                  content: Text('Some error occurred. Please try later '),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return;
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(
                              color: Color(0xFFFFFFFF), width: 2.0)))),
              child: Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Update Profile',
                        style:
                            TextStyle(color: Color(0xFF3E5A81), fontSize: 20),
                      )
                    ]),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ]),
        ),
      ),
    ));
  }
}
