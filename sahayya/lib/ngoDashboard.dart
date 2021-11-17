import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NGODashboard extends StatefulWidget {
  const NGODashboard({Key? key}) : super(key: key);

  @override
  _NGODashboardState createState() => _NGODashboardState();
}

class _NGODashboardState extends State<NGODashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
      ),
    );
  }
}
