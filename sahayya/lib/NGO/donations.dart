import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sahayya/NGO/components/giveOutCard.dart';

final storage = new FlutterSecureStorage();

class Donations extends StatefulWidget {
  @override
  _DonationsState createState() => _DonationsState();

  final Map<String, dynamic> entityData;

  const Donations({required this.entityData});
}

class _DonationsState extends State<Donations> {
  String? token = '', username = '', type = '';
  // var allInstances = <Map<dynamic, dynamic>>[];
  List<dynamic> allInstances = [];
  List<GiveOutCard> allInstancesCard = [];

  void getUserData() async {
    token = await storage.read(key: 'token');
    username = await storage.read(key: 'username');
    type = await storage.read(key: 'type');

    String theURL =
        'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/get-give-outs/' +
            username!;
    final response = await http.get(Uri.parse(theURL),
        headers: {HttpHeaders.authorizationHeader: token!});

    if (response.statusCode == 200) {
      print(response.body);
      print(response.statusCode);
      Map<dynamic, dynamic> resp = jsonDecode(response.body);

      setState(() {
        // allInstances = resp['data'];
        allInstances = resp['data'];
      });

      List<GiveOutCard> theCards = [];

      for (var i = 0; i < allInstances.length; i++) {
        theCards.add(GiveOutCard(instance: allInstances[i]));
      }

      setState(() {
        allInstancesCard = theCards;
      });
      print(allInstancesCard.length);
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
      height: double.infinity,
      color: Color(0xFF3E5A81),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Give-outs around you (${allInstances.length})',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26),
                    )
                  ]),
                ),
              ),
            ]),
            Column(
              children: allInstancesCard,
            ),
          ],
        ),
      ),
    );
  }
}
