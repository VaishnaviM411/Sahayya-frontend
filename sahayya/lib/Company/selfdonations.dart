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
    return Container(
      color: Color(0xFF3E5A81),
      height: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Color(0xFFFFFFFF), width: 2.0)))),
                  child: Text('Create Give-Out', style: TextStyle(
                      color: Color(0xFF3E5A81),
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),),
                  onPressed: () {
                    Navigator.pushNamed(context, '/create-give-out');
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
