import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

    bool isLoading = true;

    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    Map<dynamic, dynamic> data = arguments['data'], userData = arguments['userData'];

    print(data);
    print(userData);



    return isLoading ? Container(
      color: Color(0xFF3E5A81),
      child: SpinKitRotatingCircle(
        color: Colors.white,
        size: 100.0,
      ),
    ):Container();
  }
}
