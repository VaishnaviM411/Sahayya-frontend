import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sahayya/Company/nearbyNGOs.dart';
import 'package:sahayya/NGO/components/companyData.dart';
import 'package:sahayya/NGO/components/forum.dart';
import 'package:sahayya/NGO/components/individualData.dart';
import 'package:http/http.dart' as http;
import 'package:sahayya/NGO/components/ngoData.dart';

final storage = new FlutterSecureStorage();

class GiveOutDetails extends StatefulWidget {
  const GiveOutDetails({Key? key}) : super(key: key);

  @override
  _GiveOutDetailsState createState() => _GiveOutDetailsState();


}

class _GiveOutDetailsState extends State<GiveOutDetails> {

  bool isLoading = true;
  String? TOKEN='', USERNAME='', TYPE='';

  void getUserData() async {
    TOKEN = await storage.read(key: 'token');
    USERNAME = await storage.read(key: 'username');
    TYPE = await storage.read(key: 'type');
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {

    int randomSetStateVariable =0;
    void triggerUpdate(){
      setState(() {
        randomSetStateVariable = 2;
      });
    }

    bool isCompany = true;

    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    Map<dynamic, dynamic> data = arguments['data'], userData = arguments['userData'], forum = arguments['forum'];
    List<dynamic> applications = arguments['applications'];

    List<MaterialInstance> availableMaterial = [];
    List<DocumentInstance> docList = [];
    List<ApplicationInstance> appsList = [];

    setState(() {
      for(var i=0; i<data['documentsArray'].length; i++){
        docList.add(DocumentInstance(link: data['documentsArray'][i], index: i+1));
      }
    });

    setState(() {
      for(var i=0; i<data['available-material'].length; i++){
        availableMaterial.add(MaterialInstance(val: data['available-material'][i]));
      }
    });

    setState(() {
      for(var i=0; i<applications.length; i++){
        appsList.add(ApplicationInstance(data: applications[i]));
      }
    });

    setState(() {
      if(userData['donorType'] == 'Individual'){
        isCompany = false;
      }
      if(userData['donorType'] == 'Company'){
        isCompany = true;
      }
    });


    Widget theAuthorCard(){
      if(userData['type'] == 'NGO'){
        return NGOData(data: userData);
      }
      if(userData['donorType'] == 'Individual'){
        return IndividualData(data: userData);
      }
      if(userData['donorType'] == 'Company'){
        return CompanyData(data: userData);
      }
      return CompanyData(data: userData);
    }

    return isLoading ? Container(
      height: double.infinity,
      color: Color(0xFF3E5A81),
      child: SpinKitRotatingCircle(
      color: Colors.white,
      size: 50.0,
    ),) : Scaffold(
      body: Container(
        color: Color(0xFF3E5A81),
        height: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),),
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Text('${data['title']}', style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 30
                          ),),
                        ),
                      ],
                    ),
                    Column(
                      children: availableMaterial,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text('${data['description']}', style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20
                          ),),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text('${data['username']}', style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                              fontSize: 20
                          ),),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text('${data['applyBy']}', style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: docList,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              theAuthorCard(),
              SizedBox(
                height: 20,
              ),
              Forum(userData: userData, forum: forum, theUsername: USERNAME!, token: TOKEN!, id: data['id'], triggerUpdate: triggerUpdate, type: TYPE!),
              SizedBox(
                height: 20,
              ),
              (userData['username'] == USERNAME!) ? (
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),),
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('Received Applications (${applications.length}) :', style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 22
                          ),),
                        ),
                        SizedBox(height: 20,),
                        Column(
                          children: appsList,
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Color(0xFFFFFFFF), width: 2.0)))),
                            child: Text('Delete Give-Out', style: TextStyle(color: Color(0xFF3E5A81), fontWeight: FontWeight.bold, fontSize: 18)),
                            onPressed: () async {
                              String theURL = 'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/particular-give-out/${data['id']}';
                              final response = await http.delete(Uri.parse(theURL), headers: {
                                HttpHeaders.authorizationHeader: TOKEN!
                              });

                              if(response.statusCode == 200){
                                final snackBar = SnackBar(
                                  content: Text('Give-Out deleted successfully'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);

                                if(userData['donorType'] == 'Individual'){
                                  Navigator.pushReplacementNamed(context, '/indvDonor');
                                }
                                else{
                                  Navigator.pushReplacementNamed(context, '/compDonor');
                                }
                              }
                              final snackBar = SnackBar(
                                content: Text('Some error occurred'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              return;
                            },
                          ),
                        ),
                      ],
                    ),
                  )
              ) : (Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Color(0xFFFFFFFF), width: 2.0)))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                    child: Text('Apply', style: TextStyle(color: Color(0xFF3E5A81), fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  onPressed: () async {
                    Navigator.pushNamed(context, '/apply-for-donor-donation', arguments: {"id": data['id']});
                  },
                ),
              )),
            ],
          ),
        ),

      ),
    );

  }
}


class ApplicationInstance extends StatefulWidget {

  Map<dynamic, dynamic> data = {};
  ApplicationInstance({required this.data});

  @override
  _ApplicationInstanceState createState() => _ApplicationInstanceState();
}

class _ApplicationInstanceState extends State<ApplicationInstance> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: Text('${widget.data['title']}', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20
                ),),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text('${widget.data['body']}', style: TextStyle(
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
                child: Text('${widget.data['username']}', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    fontSize: 15
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
    );
  }
}



class DocumentInstance extends StatefulWidget {
  String link = '';
  int index = -1;

  DocumentInstance({required this.link, required this.index});

  @override
  _DocumentInstanceState createState() => _DocumentInstanceState();
}

class _DocumentInstanceState extends State<DocumentInstance> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ElevatedButton(
        onPressed: (){
          Navigator.pushNamed(context, '/pdf', arguments: {
            "link": widget.link
          });
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: Center(
            child: Text('Document ${widget.index}', style: TextStyle(
              color: Color(0xFF3E5A81),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),),
          ),

        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Color(0xFFFFFFFF), width: 2.0)))),
      ),
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
      margin: EdgeInsets.symmetric(vertical: 9, horizontal: 25),
      width: double.infinity,
      padding: EdgeInsets.all(5),
      child: Center(
        child: Text('${widget.val}', style: TextStyle(
            color: Color(0xFF3E5A81),
            fontSize: 18,
            fontWeight: FontWeight.w700,
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