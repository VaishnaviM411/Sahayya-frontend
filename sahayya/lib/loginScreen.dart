import 'package:flutter/material.dart';
import 'package:sahayya/allBrains/loginBrain.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
                    var jwt = await LoginBrain().loginAttempt(
                      _usernameController.text,
                      _passwordController.text,
                    );
                    if (jwt != null) {
                      storage.write(
                        key: "username",
                        value: _usernameController.text,
                      );
                      storage.write(
                        key: "jwt",
                        value: jwt.toString(),
                      );
                      storage.write(
                        key: "",
                        value:"",
                      );
                    }
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
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
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
