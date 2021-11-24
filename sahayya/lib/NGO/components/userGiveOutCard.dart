import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final storage = new FlutterSecureStorage();

class UserGiveOutCard extends StatefulWidget {
  Map<dynamic, dynamic> instance = {};
  UserGiveOutCard({required this.instance});

  @override
  _UserGiveOutCardState createState() => _UserGiveOutCardState();
}

class _UserGiveOutCardState extends State<UserGiveOutCard> {
  String? TOKEN = '', USERNAME = '', TYPE = '';

  void getUserData() async {
    TOKEN = await storage.read(key: 'token');
    USERNAME = await storage.read(key: 'username');
    TYPE = await storage.read(key: 'type');
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.instance);

    //print(widget.instance);
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: double.infinity,
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '${widget.instance['title']}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      )
                    ]),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '${widget.instance['body']}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      )
                    ]),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '${widget.instance['status']}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                            fontSize: 16),
                      )
                    ]),
                  ),
                ),
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
      onTap: () async {
        Map<dynamic, dynamic> requestData = widget.instance;
        Map<dynamic, dynamic> theGiveOutDetailsData = {};
        Map<dynamic, dynamic> theDonorWhoIsGivingData = {};

        ///give-out-application/:id

        var response;
        String theURL =
            'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/particular-give-out/' +
                widget.instance['requestID'];
        response = await http.get(Uri.parse(theURL),
            headers: {HttpHeaders.authorizationHeader: TOKEN!});

        if (response.statusCode == 200) {
          Map<String, dynamic> resp = jsonDecode(response.body);
          setState(() {
            theGiveOutDetailsData = resp;
          });
        } else {
          final snackBar = SnackBar(
            content: Text('Some error occurred. Try again later.'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }

        String theDonorUsername = theGiveOutDetailsData['username'];

        theURL =
            'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/profile/' +
                theDonorUsername;
        response = await http.get(Uri.parse(theURL),
            headers: {HttpHeaders.authorizationHeader: TOKEN!});

        if (response.statusCode == 200) {
          Map<String, dynamic> resp = jsonDecode(response.body);
          setState(() {
            theDonorWhoIsGivingData = resp;
          });
        } else {
          final snackBar = SnackBar(
            content: Text('Some error occurred. Try again later.'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }

        // Navigator.pushNamed(context, '/applicationPageDonationGiveout', arguments: {
        //   "requestData": requestData,
        //   "theGiveOutDetailsData": theGiveOutDetailsData,
        //   "theDonorWhoIsGivingData": theDonorWhoIsGivingData,
        //   "id": widget.instance['requestID']
        // });

        Navigator.pushNamed(context, '/applicationPageNGORequest', arguments: {
          "requestData": requestData,
          "theGiveOutDetailsData": theGiveOutDetailsData,
          "theDonorWhoIsGivingData": theDonorWhoIsGivingData,
          "id": widget.instance['requestID']
        });
        return;
      },
    );
  }
}

class MaterialInstance extends StatefulWidget {
  String val = '';

  MaterialInstance({required this.val});

  @override
  _MaterialInstanceState createState() => _MaterialInstanceState();
}

class _MaterialInstanceState extends State<MaterialInstance> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
      width: double.infinity,
      padding: EdgeInsets.all(5),
      child: Center(
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: '${widget.val}',
              style: TextStyle(
                  color: Color(0xFF3E5A81),
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            )
          ]),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
    );
  }
}
