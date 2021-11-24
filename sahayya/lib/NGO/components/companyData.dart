import 'package:flutter/material.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class CompanyData extends StatefulWidget {

  Map<dynamic, dynamic> data = {};
  CompanyData({required this.data});

  @override
  _CompanyDataState createState() => _CompanyDataState();
}

class _CompanyDataState extends State<CompanyData> {

  File? _image;

  Future<File> urlToFile(String imageUrl) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  void setImage() async {
    print(widget.data['picture']);
    File tempo = await urlToFile(widget.data['picture']);
    setState(() {
      _image = tempo;
    });
  }

  @override
  void initState() {
    super.initState();
    setImage();
  }

  @override
  Widget build(BuildContext context) {

    Map<dynamic, dynamic> data = widget.data;

    List<MaterialInstance> availableMaterial = [];

    setState(() {
      for(var i=0; i<data['sectors'].length; i++){
        availableMaterial.add(MaterialInstance(val: data['sectors'][i]));
      }
    });

    String statusOfCompany = '(Unverified)';

    setState(() {
      if(data['isVerified']){
        statusOfCompany = '(Verified)';
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
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 65,
                child: ClipOval(
                  child: (_image != null)
                      ? Image.file(
                    _image!,
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child:RichText(
                  text: TextSpan(children: [
                    TextSpan(text: '${data['name']}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 30
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
                    TextSpan(text: statusOfCompany,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                      ),)
                  ]),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
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
                  text: TextSpan(children: [
                    TextSpan(text: '${data['description']}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
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
                child:Text('${data['email']}', style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    fontSize: 16
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
                  text: TextSpan(children: [
                    TextSpan(text: '${data['email']}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          fontSize: 16
                      ),)
                  ]),
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child:Text('${data['address']}', style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child:RichText(
                  text: TextSpan(children: [
                    TextSpan(text: '${data['address']}',
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
          SizedBox(
            height: 20,
          ),
        ],
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