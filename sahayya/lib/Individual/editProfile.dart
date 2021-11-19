import 'package:flutter/material.dart';

class EditNGOProfile extends StatefulWidget {
  const EditNGOProfile({Key? key}) : super(key: key);

  @override
  _EditNGOProfileState createState() => _EditNGOProfileState();
}

class _EditNGOProfileState extends State<EditNGOProfile> {
  int _selectedIndex = 3;
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
        body: Container(
          color: Color(0xFF3E5A81),
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
