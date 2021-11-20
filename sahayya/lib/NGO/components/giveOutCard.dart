import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final storage = new FlutterSecureStorage();
class GiveOutCard extends StatefulWidget {

  Map<dynamic, dynamic> instance = {};
  GiveOutCard({required this.instance});

  @override
  _GiveOutCardState createState() => _GiveOutCardState();
}

class _GiveOutCardState extends State<GiveOutCard> {


  String? TOKEN='', USERNAME='', TYPE='';

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

    List<MaterialInstance> availableMaterial = [];

    setState(() {
      for(var i=0; i<widget.instance['available-material'].length; i++){
        availableMaterial.add(MaterialInstance(val: widget.instance['available-material'][i]));
      }
    });


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
                  child: Text('${widget.instance['title']}', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20
                  ),),
                ),
              ],
            ),
            Column(
              children: availableMaterial,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text('${widget.instance['description']}', style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                  ),),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text('${widget.instance['username']}', style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      fontSize: 15
                  ),),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text('${widget.instance['applyBy']}', style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),),
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
            ),),
      ),
      onTap: ()async{

        Map<dynamic, dynamic> userDetails = {};
        Map<dynamic, dynamic> forum = {};

        String theURL = 'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/profile/'+widget.instance['username'];
        final response = await http.get(Uri.parse(theURL), headers: {
          HttpHeaders.authorizationHeader: TOKEN!
        });

        if(response.statusCode == 200) {
          print(response.statusCode);
          Map<String, dynamic> resp = jsonDecode(response.body);
          setState(() {
            userDetails = resp;
          });

          print(widget.instance['id']);

          String theURL2 = 'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/forum/' + widget.instance['id'].toString();
          final response2 = await http.get(Uri.parse(theURL2), headers: {
            HttpHeaders.authorizationHeader: TOKEN!
          });

          if (response2.statusCode == 200) {
            print(response.statusCode);
            Map<String, dynamic> resp2 = jsonDecode(response2.body);
            setState(() {
              forum = resp2;
            });

            Navigator.pushNamed(context, '/giveOutDetails', arguments: {
              "data": widget.instance,
              "userData": userDetails,
              "forum": forum
            });
            return;
          }
        }
        final snackBar = SnackBar(
          content: Text('Some error occurred. Try again later.'),
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar);
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
        child: Text('${widget.val}', style: TextStyle(
          color: Color(0xFF3E5A81),
          fontWeight: FontWeight.w700
        ),),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),),
    );
  }
}
