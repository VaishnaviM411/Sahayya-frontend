import 'package:flutter/material.dart';

class DonationRequests extends StatefulWidget {
  @override
  _DonationRequestsState createState() => _DonationRequestsState();
  final Map<String, dynamic> entityData;

  const DonationRequests({required this.entityData});
}

class _DonationRequestsState extends State<DonationRequests> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF3E5A81),
      height: double.infinity,
    );
  }
}
