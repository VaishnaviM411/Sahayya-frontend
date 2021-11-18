import 'package:flutter/material.dart';

class Donations extends StatefulWidget {

  @override
  _DonationsState createState() => _DonationsState();

  final Map<String, dynamic> entityData;

  const Donations({required this.entityData});
}

class _DonationsState extends State<Donations> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.amberAccent,);
  }
}
