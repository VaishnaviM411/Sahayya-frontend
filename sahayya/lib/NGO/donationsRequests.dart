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
    return Scaffold(
      backgroundColor: Color(0xFF3E5A81),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: SingleChildScrollView(
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
                      child: Text('Create Donation Request', style: TextStyle(
                          color: Color(0xFF3E5A81),
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),),
                      onPressed: () {
                        Navigator.pushNamed(context, '/create-ngo-request');
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
