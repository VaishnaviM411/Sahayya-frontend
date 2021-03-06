import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final storage = new FlutterSecureStorage();
class CardNGOApplication extends StatefulWidget {

  Map<dynamic, dynamic> instance = {};
  CardNGOApplication({required this.instance});

  @override
  _CardNGOApplicationState createState() => _CardNGOApplicationState();
}

class _CardNGOApplicationState extends State<CardNGOApplication> {

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
      for(var i=0; i<widget.instance['requirements'].length; i++){
        availableMaterial.add(MaterialInstance(val: widget.instance['requirements'][i]));
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
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(text: '${widget.instance['title']}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20
                        ),)
                    ]),
                  ),
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
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(text: '${widget.instance['description']}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),)
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
                      TextSpan(text: '${widget.instance['applyBy']}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                            fontSize: 16
                        ),)
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
          ),),
      ),
      onTap: ()async{

        Map<dynamic, dynamic> userDetails = {};
        Map<dynamic, dynamic> forum = {};
        Map<dynamic, dynamic> applications = {};

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

            String theURL3 = 'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/all-received-applications-for-donor/' + widget.instance['id'].toString();
            final response3 = await http.get(Uri.parse(theURL3), headers: {
              HttpHeaders.authorizationHeader: TOKEN!
            });

            if (response3.statusCode == 200) {
              Map<String, dynamic> resp3 = jsonDecode(response3.body);
              setState(() {
                applications = resp3;
              });

              print(applications);

              Map<dynamic, dynamic> data = widget.instance;
              data['available-material'] = data['requirements'];

              Navigator.pushNamed(context, '/giveOutDetails', arguments: {
                "data": widget.instance,
                "userData": userDetails,
                "forum": forum,
                "applications": applications['data']
              });
              return;
            }
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
        child: RichText(
          text: TextSpan(children: [
            TextSpan(text: '${widget.val}',
              style: TextStyle(
                  color: Color(0xFF3E5A81),
                  fontWeight: FontWeight.w700,
                  fontSize: 20
              ),)
          ]),
        ),

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
