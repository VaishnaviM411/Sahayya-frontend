import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'donationRequests.dart';
import 'nearbyNGOs.dart';
import 'profile.dart';
import 'selfdonations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class CompanyDonor extends StatefulWidget {
  const CompanyDonor({Key? key}) : super(key: key);

  @override
  _CompanyDonorState createState() => _CompanyDonorState();
}

class _CompanyDonorState extends State<CompanyDonor> {
  Map<String, dynamic> entityData = {};
  String? token = '', username = '', type = '';

  void getStorageValues() async {
    token = await storage.read(key: 'token');
    username = await storage.read(key: 'username');
    type = await storage.read(key: 'type');
  }

  void getUserData(username, token) async {
    token = await storage.read(key: 'token');
    username = await storage.read(key: 'username');
    type = await storage.read(key: 'type');

    String theURL =
        'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/profile/' +
            username;
    final response = await http.get(Uri.parse(theURL),
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      print(response.statusCode);
      Map<String, dynamic> resp = jsonDecode(response.body);
      setState(() {
        entityData = resp;
      });
      return;
    }
    await storage.write(key: 'username', value: null);
    await storage.write(key: 'token', value: null);
    await storage.write(key: 'type', value: null);
    Navigator.pushReplacementNamed(context, '/start');
    return;
  }

  @override
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SAHAYYA',
          style: TextStyle(
            fontFamily: 'Lobster',
            color: Colors.white,
            fontSize: 30.0,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Center(
        child: <Widget>[
          NearbyNGOs(entityData: entityData),
          DonationRequests(entityData: entityData),
          SelfDonations(entityData: entityData),
          Profile(entityData: entityData),
        ].elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF3E5A81),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Applications',
            backgroundColor: Color(0xFF3E5A81),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Requests',
            backgroundColor: Color(0xFF3E5A81),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.loyalty),
            label: 'Donations',
            backgroundColor: Color(0xFF3E5A81),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Profile',
            backgroundColor: Color(0xFF3E5A81),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFEBBA5B),
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: false,
      ),
    );
  }
}
