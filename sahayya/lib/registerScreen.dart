import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'loginScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'utils/sectors.dart';
import 'sectorInstance.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String? _chosenValueRole;
  bool _passwordVisible = false;

  String username = '',
      password = '',
      cpassword = '',
      email = '',
      name = '',
      city = '',
      state = '',
      address = '',
      description = '',
      fName = '',
      lName = '',
      location = '',
      bio = '',
      contactNo = '',
      imageURL =
          'https://firebasestorage.googleapis.com/v0/b/bizrep-b0184.appspot.com/o/profile_picture.png?alt=media&token=f23c3431-328e-47d6-8e0c-a1dfabbf13bf';

  double latitude = 0.0, longitude = 0.0;

  String type = '';

  List<String> selectedSectors = [];

  List<String> allTheSectors = [];

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

  void setImage() async {
    File tempo = await urlToFile(profilePic);
    setState(() {
      _image = tempo;
    });
  }

  @override
  void initState() {
    super.initState();
    setImage();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
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
      print(value);
      setState(() {
        allTheSectors.add(value);
        selectedSectors.remove(value);
        selectedSectorInstances
            .remove(SectorInstance(value, deleteSectorInstance));
        myTrigger = 25;
      });
      print(allTheSectors);
      print(selectedSectors);
      print("Hey Angel");
    }

    return Scaffold(
      backgroundColor: Color(0xFF3E5A81),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10.0),
              Center(
                child: Text(
                  'SAHAYYA',
                  style: TextStyle(
                    fontFamily: 'Lobster',
                    color: Colors.white,
                    fontSize: 60.0,
                    letterSpacing: 5.5,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      getImage();
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
                  TextField(
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: 'Username',
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
                        username = val;
                      });
                    },
                  ),
                  SizedBox(height: 40.0),
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
                      hintText: 'Email',
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  SizedBox(height: 40.0),
                  TextField(
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                    enabled: true,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF3E5A81),
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      border: border(context),
                      enabledBorder: border(context),
                      focusedBorder: focusBorder(context),
                      hintText: 'Password',
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  SizedBox(height: 40.0),
                  TextField(
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                    enabled: true,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Color(0xFF3E5A81),
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: border(context),
                      enabledBorder: border(context),
                      focusedBorder: focusBorder(context),
                      hintText: 'Confirm Password',
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: (val) {
                      setState(() {
                        cpassword = val;
                      });
                    },
                  ),
                  SizedBox(height: 40.0),
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
                        value: _chosenValueRole,
                        style: TextStyle(color: Colors.white),
                        dropdownColor: Color(0xFF3E5A81),
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        iconSize: 50.0,
                        iconEnabledColor: Colors.white70,
                        isExpanded: true,
                        items: <String>[
                          'NGO',
                          'Company Donor',
                          'Individual Donor',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          "    Role",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            myTrigger = 20;
                            _chosenValueRole = value!;
                            selectedSectors = [];
                            selectedSectorInstances = [];
                            allTheSectors = [];
                            if (value == 'NGO') {
                              allTheSectors = ngoSectors;
                            }
                            if (value == 'Company Donor') {
                              allTheSectors = industrySectors;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  Visibility(
                      visible: _chosenValueRole == 'NGO' ||
                              _chosenValueRole == 'Company Donor'
                          ? true
                          : false,
                      child: SizedBox(height: 40.0)),
                  Visibility(
                    visible: _chosenValueRole == 'NGO' ||
                            _chosenValueRole == 'Company Donor'
                        ? true
                        : false,
                    child: Container(
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
                              selectedSectorInstances.add(
                                  SectorInstance(value, deleteSectorInstance));
                              _chosenSector = allTheSectors[0];
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: selectedSectorInstances,
                  ),
                  Visibility(
                    visible: _chosenValueRole == 'NGO' ||
                            _chosenValueRole == 'Company Donor'
                        ? true
                        : false,
                    child: SizedBox(height: 40.0),
                  ),
                  Visibility(
                    visible: _chosenValueRole == 'NGO' ||
                            _chosenValueRole == 'Company Donor'
                        ? true
                        : false,
                    child: TextField(
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
                        hintText: 'Name',
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible:
                        _chosenValueRole == 'Individual Donor' ? true : false,
                    child: SizedBox(height: 40.0),
                  ),
                  Visibility(
                    visible:
                        _chosenValueRole == 'Individual Donor' ? true : false,
                    child: TextField(
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
                        hintText: 'First Name',
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (val) {
                        setState(() {
                          fName = val;
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible:
                        _chosenValueRole == 'Individual Donor' ? true : false,
                    child: SizedBox(height: 40.0),
                  ),
                  Visibility(
                    visible:
                        _chosenValueRole == 'Individual Donor' ? true : false,
                    child: TextField(
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
                        hintText: 'Last Name',
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (val) {
                        setState(() {
                          lName = val;
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: _chosenValueRole == 'NGO' ||
                            _chosenValueRole == 'Company Donor'
                        ? true
                        : false,
                    child: SizedBox(height: 40.0),
                  ),
                  Visibility(
                    visible: _chosenValueRole == 'NGO' ||
                            _chosenValueRole == 'Company Donor'
                        ? true
                        : false,
                    child: Container(
                      child: Theme(
                        data: ThemeData(
                          primaryColor: Color(0xFF3E5A81),
                        ),
                        child: TextField(
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
                            hintText: "Description",
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
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        _chosenValueRole == 'Individual Donor' ? true : false,
                    child: SizedBox(height: 40.0),
                  ),
                  Visibility(
                    visible:
                        _chosenValueRole == 'Individual Donor' ? true : false,
                    child: Container(
                      child: Theme(
                        data: ThemeData(
                          primaryColor: Color(0xFF3E5A81),
                        ),
                        child: TextField(
                          onChanged: (val) {
                            setState(() {
                              bio = val;
                            });
                          },
                          style: TextStyle(color: Colors.white),
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: "Bio",
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
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _chosenValueRole == 'NGO' ? true : false,
                    child: SizedBox(height: 40.0),
                  ),
                  Visibility(
                    visible: _chosenValueRole == 'NGO' ? true : false,
                    child: TextField(
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                      enabled: true,
                      decoration: InputDecoration(
                        hintText: 'City',
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
                          city = val;
                        });
                      },
                    ),
                  ),
                  Visibility(
                      visible: _chosenValueRole == 'NGO' ? true : false,
                      child: SizedBox(height: 40.0)),
                  Visibility(
                    visible: _chosenValueRole == 'NGO' ? true : false,
                    child: TextField(
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
                        hintText: 'State',
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (val) {
                        setState(() {
                          state = val;
                        });
                      },
                    ),
                  ),
                  Visibility(
                      visible: _chosenValueRole == 'NGO' ||
                              _chosenValueRole == 'Company Donor'
                          ? true
                          : false,
                      child: SizedBox(height: 40.0)),
                  Visibility(
                    visible: _chosenValueRole == 'NGO' ||
                            _chosenValueRole == 'Company Donor'
                        ? true
                        : false,
                    child: TextField(
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
                        hintText: 'Address',
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (val) {
                        setState(() {
                          address = val;
                        });
                      },
                    ),
                  ),
                  Visibility(
                      visible:
                          _chosenValueRole == 'Individual Donor' ? true : false,
                      child: SizedBox(height: 40.0)),
                  Visibility(
                    visible:
                        _chosenValueRole == 'Individual Donor' ? true : false,
                    child: TextField(
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
                        hintText: 'Location',
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (val) {
                        setState(() {
                          location = val;
                        });
                      },
                    ),
                  ),
                  Visibility(
                      visible:
                          _chosenValueRole == 'Company Donor' ? true : false,
                      child: SizedBox(height: 40.0)),
                  Visibility(
                    visible: _chosenValueRole == 'Company Donor' ? true : false,
                    child: TextField(
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
                        hintText: 'Contact Number',
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (val) {
                        setState(() {
                          contactNo = val;
                        });
                      },
                    ),
                  ),
                  Visibility(
                      visible: _chosenValueRole == "NGO" ||
                              _chosenValueRole == "Individual Donor" ||
                              _chosenValueRole == "Company Donor"
                          ? true
                          : false,
                      child: SizedBox(height: 40.0)),
                  Visibility(
                    visible: _chosenValueRole == "NGO" ||
                            _chosenValueRole == "Individual Donor" ||
                            _chosenValueRole == "Company Donor"
                        ? true
                        : false,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (username.length == 0) {
                          final snackBar = SnackBar(
                            content: Text('Please enter a username'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }

                        if (password.length == 0) {
                          final snackBar = SnackBar(
                            content: Text('Please enter a Password'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }

                        if (cpassword.length == 0) {
                          final snackBar = SnackBar(
                            content: Text('Please enter a Confirm Password'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }

                        if (password != cpassword) {
                          final snackBar = SnackBar(
                            content: Text(
                                'Password and Confirm Password do not match'),
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
                        if (_chosenValueRole == 'NGO') {
                          setState(() {
                            type = 'NGO';
                          });

                          if (name.length == 0) {
                            final snackBar = SnackBar(
                              content: Text('Please enter Name'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }
                          if (city.length == 0) {
                            final snackBar = SnackBar(
                              content: Text('Please enter city '),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }
                          if (state.length == 0) {
                            final snackBar = SnackBar(
                              content: Text('Please enter a state'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }
                          if (address.length == 0) {
                            final snackBar = SnackBar(
                              content: Text('Please enter address. '),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }
                          if (description.length == 0) {
                            final snackBar = SnackBar(
                              content: Text('Please enter description'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }
                          if (selectedSectors.isEmpty) {
                            final snackBar = SnackBar(
                              content: Text('Please select a sector. '),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }

                          Map<String, dynamic> theData = {
                            "username": username,
                            "email": email,
                            "password": password,
                            "coOrdinates": {
                              "latitude": latitude,
                              "longitude": longitude
                            },
                            "picture": imageURL,
                            "name": name,
                            "city": city,
                            "state": state,
                            "address": address,
                            "sectors": selectedSectors,
                            "description": description,
                          };

                          print(theData);

                          JsonEncoder encoder = JsonEncoder();
                          final dynamic object = encoder.convert(theData);

                          print(object);

                          final response = await http.post(
                              Uri.parse(
                                  'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/ngo-signup'),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                              },
                              body: json.encode(theData));

                          print(response.statusCode);
                          print(response.body);

                          if (response.statusCode == 403) {
                            final snackBar = SnackBar(
                              content: Text('Username already exists. '),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }

                          if (response.statusCode == 201) {
                            final snackBar = SnackBar(
                              content: Text('NGO signed up successfully. '),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);

                            Map<String, dynamic> resp =
                                json.decode(response.body);

                            await storage.write(
                                key: 'username', value: username);
                            await storage.write(
                                key: 'token', value: resp['token']);
                            await storage.write(key: 'type', value: type);
                            //route to ngoDashboard
                            Navigator.pushReplacementNamed(
                                context, '/ngoDashboard');
                            return;
                          }
                          final snackBar = SnackBar(
                            content:
                                Text('Some error occurred. Please try later '),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        } else if (_chosenValueRole == 'Individual Donor') {
                          setState(() {
                            type = 'Individual';
                          });

                          if (fName.length == 0) {
                            final snackBar = SnackBar(
                              content: Text('Please enter first name '),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }
                          if (lName.length == 0) {
                            final snackBar = SnackBar(
                              content: Text('Please enter last name '),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }
                          if (location.length == 0) {
                            final snackBar = SnackBar(
                              content: Text('Please enter your location '),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }
                          if (bio.length == 0) {
                            final snackBar = SnackBar(
                              content: Text(
                                  'Please enter something about you in the Bio. '),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }

                          Map<String, dynamic> theData = {
                            "username": username,
                            "email": email,
                            "password": password,
                            "coOrdinates": {
                              "latitude": latitude,
                              "longitude": longitude
                            },
                            "picture": imageURL,
                            "fName": fName,
                            "lName": lName,
                            "location": location,
                            "bio": bio,
                          };

                          print(theData);

                          JsonEncoder encoder = JsonEncoder();
                          final dynamic object = encoder.convert(theData);

                          print(object);

                          final response = await http.post(
                              Uri.parse(
                                  'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/donor-individual-signup'),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                              },
                              body: json.encode(theData));

                          print(response.statusCode);
                          print(response.body);

                          if (response.statusCode == 403) {
                            final snackBar = SnackBar(
                              content: Text('Username already exists. '),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }

                          if (response.statusCode == 201) {
                            final snackBar = SnackBar(
                              content: Text(
                                  'Individual Donor signed up successfully. '),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);

                            Map<String, dynamic> resp =
                                json.decode(response.body);

                            await storage.write(
                                key: 'username', value: username);
                            await storage.write(
                                key: 'token', value: resp['token']);
                            await storage.write(key: 'type', value: type);

                            Navigator.pushReplacementNamed(
                                context, '/indvDonor');

                            return;
                          }
                          final snackBar = SnackBar(
                            content:
                                Text('Some error occurred. Please try later '),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        } else if (_chosenValueRole == 'Company Donor') {
                          setState(() {
                            type = 'Company';
                          });

                          if (name.length == 0) {
                            final snackBar = SnackBar(
                              content: Text('Please enter Name '),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }
                          if (address.length == 0) {
                            final snackBar = SnackBar(
                              content: Text('Please enter Address '),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }
                          if (contactNo.length == 0) {
                            final snackBar = SnackBar(
                              content: Text('Please enter Contact Number'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }
                          if (description.length == 0) {
                            final snackBar = SnackBar(
                              content: Text('Please enter Description '),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }
                          if (selectedSectors.isEmpty) {
                            final snackBar = SnackBar(
                              content:
                                  Text('Please select at least one sector '),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }

                          Map<String, dynamic> theData = {
                            "username": username,
                            "email": email,
                            "password": password,
                            "coOrdinates": {
                              "latitude": latitude,
                              "longitude": longitude
                            },
                            "picture": imageURL,
                            "name": name,
                            "address": address,
                            "contactNo": contactNo,
                            "sectors": selectedSectors,
                            "description": description
                          };

                          JsonEncoder encoder = JsonEncoder();
                          final dynamic object = encoder.convert(theData);

                          final response = await http.post(
                              Uri.parse(
                                  'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/donor-company-signup'),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                              },
                              body: json.encode(theData));

                          if (response.statusCode == 403) {
                            final snackBar = SnackBar(
                              content: Text('Username already exists. '),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            return;
                          }

                          if (response.statusCode == 201) {
                            final snackBar = SnackBar(
                              content: Text(
                                  'Company Donor signed up successfully. '),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);

                            Map<String, dynamic> resp =
                                json.decode(response.body);

                            await storage.write(
                                key: 'username', value: username);
                            await storage.write(
                                key: 'token', value: resp['token']);
                            await storage.write(key: 'type', value: type);

                            Navigator.pushReplacementNamed(
                                context, '/compDonor');
                            return;
                          }
                          final snackBar = SnackBar(
                            content:
                                Text('Some error occurred. Please try later '),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side:
                                  BorderSide(color: Colors.white, width: 2.0)),
                        ),
                      ),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            'REGISTER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23.0,
                              letterSpacing: 5.5,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
}
