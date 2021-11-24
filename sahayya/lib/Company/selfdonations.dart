import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sahayya/NGO/components/giveOutCard.dart';
import 'components/userGiveOutCard.dart';

final storage = new FlutterSecureStorage();

class SelfDonations extends StatefulWidget {
  @override
  _SelfDonationsState createState() => _SelfDonationsState();
  final Map<String, dynamic> entityData;
  const SelfDonations({required this.entityData});
}

class _SelfDonationsState extends State<SelfDonations> {
  String? token = '', username = '', type = '';
  // var allInstances = <Map<dynamic, dynamic>>[];
  List<dynamic> allInstances = [];
  List<UserGiveOutCard> allInstancesCard = [];
  List<dynamic> allInstances2 = [];
  List<GiveOutCard> allInstancesCard2 = [];

  void getUserData() async {
    token = await storage.read(key: 'token');
    username = await storage.read(key: 'username');
    type = await storage.read(key: 'type');

    var response;
    String theURL =
        'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/applications-applied-to-by-donor/' +
            username!;
    response = await http.get(Uri.parse(theURL),
        headers: {HttpHeaders.authorizationHeader: token!});

    if (response.statusCode == 200) {
      print(response.body);
      print(response.statusCode);
      Map<dynamic, dynamic> resp = jsonDecode(response.body);

      setState(() {
        // allInstances = resp['data'];
        allInstances = resp['data'];
      });

      List<UserGiveOutCard> theCards = [];

      for (var i = 0; i < allInstances.length; i++) {
        theCards.add(UserGiveOutCard(instance: allInstances[i]));
      }

      setState(() {
        allInstancesCard = theCards;
      });
    }

    theURL =
        'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/donation-give-outs/' +
            username!;
    response = await http.get(Uri.parse(theURL),
        headers: {HttpHeaders.authorizationHeader: token!});

    if (response.statusCode == 200) {
      Map<dynamic, dynamic> resp = jsonDecode(response.body);

      setState(() {
        allInstances2 = resp['data'];
      });

      List<GiveOutCard> theCards2 = [];

      for (var i = 0; i < allInstances2.length; i++) {
        theCards2.add(GiveOutCard(instance: allInstances2[i]));
      }

      setState(() {
        allInstancesCard2 = theCards2;
      });

      return;
    }

    await storage.write(key: 'username', value: null);
    await storage.write(key: 'token', value: null);
    await storage.write(key: 'type', value: null);
    Navigator.pushReplacementNamed(context, '/start');
    return;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF3E5A81),
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Color(0xFFFFFFFF),
                                        width: 2.0)))),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Create Give-Out',
                          style: TextStyle(
                              color: Color(0xFF3E5A81),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )
                      ]),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/create-give-out');
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Your Requests (${allInstancesCard.length}):',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )
              ]),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: allInstancesCard,
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Your Give Outs (${allInstancesCard2.length}):',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )
              ]),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: allInstancesCard2,
            ),
          ],
        ),
      ),
    );
  }
}
