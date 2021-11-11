import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF3E5A81),
        body: Column(
          children : [
            Text('SAHAYYA'),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/giftbox.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              constraints: BoxConstraints.expand(),
            ),
            MaterialButton(
              onPressed: (){},
              child: Text('Login'),
            ),
            MaterialButton(
              onPressed: (){},
              child: Text('')
            )
          ]
        ),

      ),
    );
  }
}
