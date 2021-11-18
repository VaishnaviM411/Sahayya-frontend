import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sahayya/Company/donationRequests.dart';
import 'package:sahayya/Company/nearbyNGOs.dart';
import 'profile.dart';
import 'selfdonations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class IndividualDonor extends StatefulWidget {
  const IndividualDonor({Key? key}) : super(key: key);

  @override
  _IndividualDonorState createState() => _IndividualDonorState();
}

class _IndividualDonorState extends State<IndividualDonor> {

  Map<String, dynamic> entityData = {};
  String? token='', username='', type='';

  void getStorageValues() async {
    token = await storage.read(key: 'token');
    username = await storage.read(key: 'username');
    type = await storage.read(key: 'type');
  }

  void getUserData(username, token) async {

    String theURL = 'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/profile/'+username;
    final response = await http.get(Uri.parse(theURL), headers: {
      HttpHeaders.authorizationHeader: token
    });

    if(response.statusCode == 200){
      Map<String, dynamic> resp = jsonDecode(response.body);
      setState(() {
        entityData = resp;
      });
    }
    else {
      await storage.write(key: 'username', value: null);
      await storage.write(key: 'token', value: null);
      await storage.write(key: 'type', value: null);
      Navigator.pushReplacementNamed(context, '/start');
    }
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
     DonationRequests(),
     NearbyNGOs(),
     SelfDonations(),
     Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
