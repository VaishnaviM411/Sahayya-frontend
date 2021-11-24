import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sahayya/NGO/components/ngoData.dart';

import 'NGO/components/companyData.dart';
import 'NGO/components/forum.dart';
import 'NGO/components/individualData.dart';

final storage = new FlutterSecureStorage();

class RequestDetails extends StatefulWidget {
  const RequestDetails({Key? key}) : super(key: key);

  @override
  _RequestDetailsState createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {

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
      for(var i=0; i<data['requirements'].length; i++){
        availableMaterial.add(MaterialInstance(val: data['requirements'][i]));
      }
    });

    setState(() {
      for(var i=0; i<applications.length; i++){
        appsList.add(ApplicationInstance(data: applications[i], token: TOKEN,));
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
                          child:RichText(
                            text: TextSpan(children:[
                              TextSpan(text:'${data['title']}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30),
                              ),],
                            ),)                        ),
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
                          child:RichText(
                            text: TextSpan(children:[
                              TextSpan(text:'${data['description']}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                              ),],
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
                          child:RichText(
                            text: TextSpan(children:[
                              TextSpan(text:'${data['username']}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 20),
                              ),],
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
                          child: RichText(
                            text: TextSpan(children:[
                              TextSpan(text: '${data['applyBy']}',
                                style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 18),
                              ),],
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
                          child: RichText(
                            text: TextSpan(children:[
                              TextSpan(text:'Received Applications (${applications.length}) :',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,

                                    fontWeight:FontWeight.w700,
                                ),
                              ),],
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
                            child:RichText(
                              text: TextSpan(children:[
                                TextSpan(text:'Delete Request',
                                  style: TextStyle(
                                      color: Color(0xFF3E5A81),
                                      fontWeight: FontWeight.bold,

                                      fontSize: 18),
                                ),],
                              ),),

                            onPressed: () async {
                              String theURL = 'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/particular-donation-request/${data['id']}';
                              final response = await http.delete(Uri.parse(theURL), headers: {
                                HttpHeaders.authorizationHeader: TOKEN!
                              });

                              if(response.statusCode == 200){
                                final snackBar = SnackBar(
                                  content: Text('Give-Out deleted successfully'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);

                                if (TYPE == 'NGO') {
                                  Navigator.pushReplacementNamed(context, '/ngoDashboard');
                                } else if (TYPE == 'Donor') {
                                  Navigator.pushReplacementNamed(context, '/indvDonor');
                                } else if (TYPE == 'Company') {
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
                    child: RichText(
                      text: TextSpan(children:[
                        TextSpan(text:'Apply',
                          style: TextStyle(
                              color: Color(0xFF3E5A81),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),],
                      ),),
                  ),
                  onPressed: () async {
                    Navigator.pushNamed(context, '/apply-for-ngo-help', arguments: {"id": data['id']});
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
  String? token;
  ApplicationInstance({required this.data, required this.token});

  @override
  _ApplicationInstanceState createState() => _ApplicationInstanceState();
}

class _ApplicationInstanceState extends State<ApplicationInstance> {
  @override
  Widget build(BuildContext context) {
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
                  child:RichText(
                    text: TextSpan(children:[
                      TextSpan(text:'${widget.data['title']}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),],
                    ),),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: RichText(
                    text: TextSpan(children:[
                      TextSpan(text:'${widget.data['body']}',
                        style: TextStyle(
                             color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),],
                    ),),

                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: RichText(
                    text: TextSpan(children:[
                      TextSpan(text:'${widget.data['e']}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontStyle:FontStyle.italic,

                            fontSize: 15),
                      ),],
                    ),), //akku wait kar naaa okkii sorry kr tera
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

        print(widget.data);
        Map<dynamic, dynamic> requestData = widget.data;
        Map<dynamic, dynamic> theGiveOutDetailsData = {};
        Map<dynamic, dynamic> theDonorWhoIsGivingData = {};

        var response;
        String theURL = 'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/particular-give-out/'+widget.data['requestID'];
        response = await http.get(Uri.parse(theURL), headers: {
          HttpHeaders.authorizationHeader: widget.token!
        });

        if(response.statusCode == 200) {
          Map<String, dynamic> resp = jsonDecode(response.body);
          setState(() {
            theGiveOutDetailsData = resp;
          });
        }
        else{
          final snackBar = SnackBar(
            content: Text('Some error occurred. Try again later.'),
          );
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBar);
          return;
        }

        String theDonorUsername = theGiveOutDetailsData['username'];

        theURL = 'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/profile/'+theDonorUsername;
        response = await http.get(Uri.parse(theURL), headers: {
          HttpHeaders.authorizationHeader: widget.token!
        });

        if(response.statusCode == 200) {
          Map<String, dynamic> resp = jsonDecode(response.body);
          setState(() {
            theDonorWhoIsGivingData = resp;
          });
        }
        else{
          final snackBar = SnackBar(
            content: Text('Some error occurred. Try again later.'),
          );
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBar);
          return;
        }

        theGiveOutDetailsData['requirements'] = theGiveOutDetailsData['available-material'];

        Navigator.pushNamed(context, '/applicationPageNGORequest', arguments: {
          "requestData": requestData,
          "theGiveOutDetailsData": theGiveOutDetailsData,
          "theDonorWhoIsGivingData": theDonorWhoIsGivingData,
          "id": widget.data['requestID']
        });
        return;
      },
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