import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sahayya/NGO/components/companyData.dart';
import 'package:sahayya/NGO/components/forum.dart';
import 'package:sahayya/NGO/components/individualData.dart';

final storage = new FlutterSecureStorage();

class GiveOutDetails extends StatefulWidget {
  const GiveOutDetails({Key? key}) : super(key: key);

  @override
  _GiveOutDetailsState createState() => _GiveOutDetailsState();


}

class _GiveOutDetailsState extends State<GiveOutDetails> {


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

    int randomSetStateVariable =0;
    void triggerUpdate(){
      setState(() {
         randomSetStateVariable = 2;
      });
    }

    bool isCompany = true;

    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    Map<dynamic, dynamic> data = arguments['data'], userData = arguments['userData'], forum = arguments['forum'];

    List<MaterialInstance> availableMaterial = [];
    List<DocumentInstance> docList = [];

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
      if(userData['donorType'] == 'Individual'){
        isCompany = false;
      }
      if(userData['donorType'] == 'Company'){
        isCompany = true;
      }
    });




    return Scaffold(
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
              isCompany ? CompanyData(data: userData) : IndividualData(data: userData),
              SizedBox(
                height: 20,
              ),
              Forum(userData: userData, forum: forum, theUsername: USERNAME!, token: TOKEN!,)
            ],
          ),
        ),

      ),
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