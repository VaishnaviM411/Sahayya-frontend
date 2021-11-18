import 'package:flutter/material.dart';

class DonationsRequest extends StatefulWidget {
  final Map<String, dynamic> entityData;

  const DonationsRequest({required this.entityData});

  @override
  _DonationsRequestState createState() => _DonationsRequestState();
}

class _DonationsRequestState extends State<DonationsRequest> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.deepOrangeAccent,);
  }
}
