import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}


class _StartScreenState extends State<StartScreen> {


  String? token='', username='', type='';

  void getStorageValues() async {
    token = await storage.read(key: 'token');
    username = await storage.read(key: 'username');
    type = await storage.read(key: 'type');

    if(username != null){
      if(username!.length > 0){
        if(type == 'NGO'){
          Navigator.pushReplacementNamed(context, '/ngoDashboard');
        }
        else if(type=='Individual'){
          Navigator.pushReplacementNamed(context, '/indvDonor');
        }
        else if(type=='Company'){
          Navigator.pushReplacementNamed(context, '/compDonor');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getStorageValues();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF3E5A81),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children : [
              Text('SAHAYYA',style: TextStyle(
                fontFamily: 'Lobster',
                color: Colors.white,
                fontSize: 60.0,
                letterSpacing: 5.5,
              ),),
              CircleAvatar(
                radius: 180.0,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('images/giftbox.png'),
              ),
                SizedBox(
                  height: 15.0,
                ),
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/login');
                },
                style:ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white,width: 2.0)
                        )
                    )
                ),
                child: Container(child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text('LOGIN',style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    letterSpacing: 5.5,
                  ),),
                ),decoration: BoxDecoration(

                  borderRadius:
                  BorderRadius.circular(20.0), ),),
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/register');
                },
                  style:ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white,width: 2.0)
                          )
                      )
                  ),
                child: Container(child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text('REGISTER',style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    letterSpacing: 5.5,
                  ),),
                ),decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius:
                    BorderRadius.circular(20.0), ),)
              )
            ]
          ),
        ),

      ),
    );
  }
}
