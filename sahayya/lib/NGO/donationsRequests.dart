import 'package:flutter/material.dart';

class DonationsRequest extends StatefulWidget {

  @override
  _DonationsRequestState createState() => _DonationsRequestState();
  final Map<String, dynamic> entityData;

  const DonationsRequest({required this.entityData});
}

class _DonationsRequestState extends State<DonationsRequest> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.deepOrangeAccent,);
  }
}
