import 'package:flutter/material.dart';
import 'package:sahayya/loginScreen.dart';
import 'package:sahayya/registerScreen.dart';
import 'startscreen.dart';
import 'registerScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primaryColor: Color(0xFF3E5A81),
      ),
      initialRoute: '/start',
      routes: {
        '/start': (context) => StartScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => Register(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

