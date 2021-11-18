import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sahayya/NGO/ngoDashboard.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String? token='', username='', type='';

  void getStorageValues() async {
    token = await storage.read(key: 'token');
    username = await storage.read(key: 'username');
    type = await storage.read(key: 'type');

    if(username != null){
      if(username!.length > 0){
        if(type == 'NGO'){
          Navigator.pushReplacementNamed(context, '/ngoDashboard');
        }
        else if(type=='Individual'){
          Navigator.pushReplacementNamed(context, '/indvDonor');
        }
        else if(type=='Company'){
          Navigator.pushReplacementNamed(context, '/compDonor');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getStorageValues();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF3E5A81),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 200.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('images/sahayya_png_logo.png'),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: TextField(
                    cursorColor: Color(0xFFE0FCFB),
                    style: TextStyle(color: Color(0xFFE0FCFB)),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide:
                              BorderSide(color: Color(0xFFE0FCFB), width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide:
                              BorderSide(color: Color(0xFFE0FCFB), width: 2.0),
                        ),
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Color(0xFFE0FCFB))),
                    controller: _usernameController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: TextField(
                    cursorColor: Color(0xFFE0FCFB),
                    style: TextStyle(color: Color(0xFFE0FCFB)),
                    obscureText: true,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide:
                              BorderSide(color: Color(0xFFE0FCFB), width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide:
                              BorderSide(color: Color(0xFFE0FCFB), width: 2.0),
                        ),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Color(0xFFE0FCFB))),
                    controller: _passwordController,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                ElevatedButton(
                  onPressed: () async {

                    String username = _usernameController.text;
                    String password = _passwordController.text;

                    if (username.length == 0) {
                      final snackBar = SnackBar(
                        content: Text('Please enter your username'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }

                    if (password.length == 0) {
                      final snackBar = SnackBar(
                        content: Text('Please enter your Password'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }

                    Map<String, dynamic> theData = {
                      "username": username,
                      "password": password,
                    };

                    final response = await http.post(
                        Uri.parse(
                            'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/login'),
                        headers: <String, String>{
                          'Content-Type':
                          'application/json; charset=UTF-8',
                        },
                        body: json.encode(theData));

                    print(response.body);
                    print(response.statusCode);

                    if(response.statusCode == 401){
                      final snackBar = SnackBar(
                        content: Text('Password Invalid. '),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
                      return;
                    }

                    if(response.statusCode == 404){
                      final snackBar = SnackBar(
                        content: Text('Username does not exist.'),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
                      return;
                    }

                    if(response.statusCode == 200){
                      final snackBar = SnackBar(
                        content: Text('Successfully Logged in.'),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);

                      Map<String, dynamic> resp = json.decode(response.body);

                      await storage.write(key: 'username', value: username);
                      await storage.write(key: 'token', value: resp['token']);
                      await storage.write(key: 'type', value: resp['data']['type']);

                      if(resp['data']['type'] == 'NGO'){
                        Navigator.pushReplacementNamed(context, '/ngoDashboard');
                      }
                      else if(resp['data']['type'] == 'Company'){
                        Navigator.pushReplacementNamed(context, '/compDonor');
                      }
                      else if(resp['data']['type'] == 'Donor'){
                        Navigator.pushReplacementNamed(context, '/indvDonor');
                      }
                      return;
                    }

                    final snackBar = SnackBar(
                      content: Text('Some error occurred. Please try later '),
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar);
                    return;
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Colors.white, width: 2.0)))),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        'LOGIN',
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
                SizedBox(
                  height: 25.0,
                ),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pushReplacementNamed(context, '/register');
                      return;
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Colors.white, width: 2.0)))),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          'CREATE ACCOUNT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23.0,
                            letterSpacing: 5.5,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    )),
                SizedBox(
                  height: 100.0,
                ),
                Text(
                  'Terms and Conditions Applied',
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
              ]),
        ),
      ),
    );
  }
}
