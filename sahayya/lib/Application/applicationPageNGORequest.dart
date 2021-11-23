import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final storage = new FlutterSecureStorage();

class ApplicationPageNGORequest extends StatefulWidget {
  const ApplicationPageNGORequest({Key? key}) : super(key: key);

  @override
  _ApplicationPageNGORequestState createState() => _ApplicationPageNGORequestState();
}

class _ApplicationPageNGORequestState extends State<ApplicationPageNGORequest> {

  String? token='', username='', type='';

  void getUserData() async {

    token = await storage.read(key: 'token');
    username = await storage.read(key: 'username');
    type = await storage.read(key: 'type');
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }


  @override
  Widget build(BuildContext context) {

    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    String applicationID = arguments['id'];




    return Container();
  }
}
