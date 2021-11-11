import 'package:flutter/material.dart';
import 'startscreen.dart';

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
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

