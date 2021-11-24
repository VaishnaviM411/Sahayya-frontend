import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:sahayya/NGO/components/companyData.dart';
import 'package:sahayya/NGO/components/individualData.dart';
import 'package:sahayya/NGO/components/ngoData.dart';

final storage = new FlutterSecureStorage();

class ApplicationPageNGORequest extends StatefulWidget {
  const ApplicationPageNGORequest({Key? key}) : super(key: key);

  @override
  _ApplicationPageNGORequestState createState() => _ApplicationPageNGORequestState();
}

class _ApplicationPageNGORequestState extends State<ApplicationPageNGORequest> {

  bool isLoading = true;
  String? token='', username='', type='';

  void getUserData() async {

    token = await storage.read(key: 'token');
    username = await storage.read(key: 'username');
    type = await storage.read(key: 'type');
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

    bool userHasTicked = false;

    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    String applicationID = arguments['id'];
    Map<dynamic, dynamic> requestData = arguments['requestData'], theGiveOutDetailsData = arguments['theGiveOutDetailsData'], theDonorWhoIsGivingData = arguments['theDonorWhoIsGivingData'];

    List<MaterialInstance> availableMaterial = [];
    List<DocumentInstance> docList = [];

    setState(() {
      for(var i=0; i<theGiveOutDetailsData['documentsArray'].length; i++){
        docList.add(DocumentInstance(link: theGiveOutDetailsData['documentsArray'][i], index: i+1));
      }
    });

    setState(() {
      for(var i=0; i<theGiveOutDetailsData['requirements'].length; i++){
        availableMaterial.add(MaterialInstance(val: theGiveOutDetailsData['requirements'][i]));
      }
    });

    setState(() {
      if(requestData['status'] == 'Accepted'){
        for(var i=0; i<requestData['completedBy'].length; i++){
          print(requestData['completedBy'][i] + " " + username);
          if(requestData['completedBy'][i] == username){
            userHasTicked = true;
          }
        }
      }
      print(userHasTicked);
    });

    print(theGiveOutDetailsData);

    Widget theAuthorCard(){
      if(theDonorWhoIsGivingData['type'] == 'NGO'){
        return NGOData(data: theDonorWhoIsGivingData);
      }
      if(theDonorWhoIsGivingData['donorType'] == 'Individual'){
        return IndividualData(data: theDonorWhoIsGivingData);
      }
      if(theDonorWhoIsGivingData['donorType'] == 'Company'){
        return CompanyData(data: theDonorWhoIsGivingData);
      }
      return CompanyData(data: theDonorWhoIsGivingData);
    }




    return isLoading ? Container(
      height: double.infinity,
      color: Color(0xFF3E5A81),
      child: SpinKitRotatingCircle(
        color: Colors.white,
        size: 50.0,
      ),) : Material(
      child: Container(
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
                          child: RichText(
                            text: TextSpan(children:[
                              TextSpan(text:'${theGiveOutDetailsData['title']}',
                                style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30),
                              ),],
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
                          child: RichText(
                            text: TextSpan(children:[
                              TextSpan(text:'${theGiveOutDetailsData['description']}',
                                style: TextStyle(color: Colors.white,
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
                              TextSpan(text:'${theGiveOutDetailsData['username']}',
                                style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.w600,
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
                              TextSpan(text:'${theGiveOutDetailsData['applyBy']}',
                                style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20),
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
              ApplicationDataInstance(data: requestData),
              SizedBox(
                height: 20,
              ),
              (username==theDonorWhoIsGivingData['username'] && requestData['status'] == 'Pending') ? Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: RichText(
                      text: TextSpan(children:[
                        TextSpan(text:'Accept or Reject the Proposal?',
                          style: TextStyle(color: Colors.white,
                              fontSize: 18),
                        ),],
                      ),),),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(CircleBorder()),
                          ),
                          child: Icon(Icons.check, color: Color(0xFF3E5A81),),
                          onPressed: () async {

                            if(requestData['giveoutID'] == null){
                              requestData['giveoutID'] = requestData['requestID'];
                            }

                            Map<String, dynamic> theData = {
                              "verdict": "accepted"
                            };
                            JsonEncoder encoder = JsonEncoder();
                            final dynamic object = encoder.convert(theData);
                            final response = await http.post(
                                Uri.parse(
                                    'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/ngo-application-pass-verdict/${requestData['username']}-${requestData['giveoutID']}'),
                                headers: <String, String>{
                                  'Content-Type':
                                  'application/json; charset=UTF-8',
                                  HttpHeaders.authorizationHeader: token!,
                                },
                                body: object);

                            print(response.body);

                            if(response.statusCode == 201){
                              final snackBar = SnackBar(
                                content: Text('Proposal Accepted Successfully'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              if (type == 'NGO') {
                                Navigator.pushReplacementNamed(context, '/ngoDashboard');
                              } else if (type == 'Donor') {
                                Navigator.pushReplacementNamed(context, '/indvDonor');
                              } else if (type == 'Company') {
                                Navigator.pushReplacementNamed(context, '/compDonor');
                              }
                              return;
                            }
                            else{
                              final snackBar = SnackBar(
                                content: Text('Some error occurred.'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              return;
                            }
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(CircleBorder()),
                          ),
                          child: Icon(Icons.close, color: Color(0xFF3E5A81),),
                          onPressed: () async {
                            if(requestData['giveoutID'] == null){
                              requestData['giveoutID'] = requestData['requestID'];
                            }
                            Map<String, dynamic> theData = {
                              "verdict": "rejected"
                            };
                            JsonEncoder encoder = JsonEncoder();
                            final dynamic object = encoder.convert(theData);
                            final response = await http.post(
                                Uri.parse(
                                    'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/ngo-application-pass-verdict/${requestData['username']}-${requestData['giveoutID']}'),
                                headers: <String, String>{
                                  'Content-Type':
                                  'application/json; charset=UTF-8',
                                  HttpHeaders.authorizationHeader: token!,
                                },
                                body: object);

                            if(response.statusCode == 201){
                              final snackBar = SnackBar(
                                content: Text('Proposal Rejected Successfully'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              if (type == 'NGO') {
                                Navigator.pushReplacementNamed(context, '/ngoDashboard');
                              } else if (type == 'Donor') {
                                Navigator.pushReplacementNamed(context, '/indvDonor');
                              } else if (type == 'Company') {
                                Navigator.pushReplacementNamed(context, '/compDonor');
                              }
                              return;
                            }
                            else{
                              final snackBar = SnackBar(
                                content: Text('Some error occurred.'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              return;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,)
                ],
              ) : SizedBox(height: 0,),
              (requestData['status'] == 'Accepted' && !userHasTicked) ? Column(
                children: [

                  Padding(padding:const EdgeInsets.symmetric(vertical: 10),
                    child:RichText(
                      text: TextSpan(children:[
                        TextSpan(text:'Did you complete your side of transaction?',
                          style: TextStyle(color: Colors.white,

                              fontSize: 18),
                        ),],
                      ),),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(CircleBorder()),
                          ),
                          child: Icon(Icons.check, color: Color(0xFF3E5A81),),
                          onPressed: () async {
                            if(requestData['giveoutID'] == null){
                              requestData['giveoutID'] = requestData['requestID'];
                            }
                            Map<String, dynamic> theData = {
                              "id": '${requestData['username']}-${requestData['giveoutID']}',
                              "username": username
                            };
                            JsonEncoder encoder = JsonEncoder();
                            final dynamic object = encoder.convert(theData);
                            final response = await http.post(
                                Uri.parse(
                                    'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/transaction-completion-side-donor-giveout'),
                                headers: <String, String>{
                                  'Content-Type':
                                  'application/json; charset=UTF-8',
                                  HttpHeaders.authorizationHeader: token!,
                                },
                                body: object);

                            print(response.body);

                            if(response.statusCode == 201){
                              final snackBar = SnackBar(
                                content: Text('Marked Successfully'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              if (type == 'NGO') {
                                Navigator.pushReplacementNamed(context, '/ngoDashboard');
                              } else if (type == 'Donor') {
                                Navigator.pushReplacementNamed(context, '/indvDonor');
                              } else if (type == 'Company') {
                                Navigator.pushReplacementNamed(context, '/compDonor');
                              }
                              return;
                            }
                            else{
                              final snackBar = SnackBar(
                                content: Text('Some error occurred.'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              return;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,)
                ],
              ) : SizedBox(height: 0,)
            ],
          ),
        ),
      ),
    );
  }
}

class ApplicationDataInstance extends StatefulWidget {

  Map<dynamic, dynamic> data = {};

  ApplicationDataInstance({required this.data});

  @override
  _ApplicationDataInstanceState createState() => _ApplicationDataInstanceState();
}

class _ApplicationDataInstanceState extends State<ApplicationDataInstance> {
  @override
  Widget build(BuildContext context) {

    List<DocumentInstance> docList = [];

    setState(() {
      for(var i=0; i<widget.data['documents'].length; i++){
        docList.add(DocumentInstance(link: widget.data['documents'][i], index: i+1));
      }
    });


    return Container(
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
                child: Text('${widget.data['title']}', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 30
                ),),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(text: '${widget.data['body']}',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20
                  ),)
              ]),
            ),

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
                  text: TextSpan(children: [
                    TextSpan(text: '${widget.data['username']}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20
                      ),)
                  ]),
                ),
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
                  text: TextSpan(children: [
                    TextSpan(text: '${widget.data['status']}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                          fontSize: 20
                      ),)
                  ]),
                ),
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
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(text: '${widget.data['title']}',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child:RichText(
                  text: TextSpan(children: [
                    TextSpan(text: '${widget.data['body']}',
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
                    TextSpan(text: '${widget.data['username']}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          fontSize: 15
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
            child: Padding(
              padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(text: 'Document ${widget.index}',
                    style: TextStyle(
                        color:  Color(0xFF3E5A81),
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        fontSize: 18
                    ),)
                ]),
              ),

            ),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: RichText(
            text: TextSpan(children: [
              TextSpan(text: '${widget.val}',
                style: TextStyle(
                    color:  Color(0xFF3E5A81),
                    fontWeight: FontWeight.w700,
                    fontSize: 18
                ),)
            ]),
          ),
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

