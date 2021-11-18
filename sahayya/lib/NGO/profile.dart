import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final Map<String, dynamic> entityData;

  const Profile({required this.entityData});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.pink,);
  }
}
