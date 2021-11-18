import 'package:flutter/material.dart';

class SelfDonations extends StatefulWidget {
  @override
  _SelfDonationsState createState() => _SelfDonationsState();
  final Map<String, dynamic> entityData;
  const SelfDonations({required this.entityData});
}

class _SelfDonationsState extends State<SelfDonations> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.amberAccent,);
  }
}
