import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

class Forum extends StatefulWidget {

  Map<dynamic,dynamic> userData = {}, forum = {};
  String theUsername = '', token='';

  Forum({required this.userData, required this.forum, required this.theUsername, required this.token});

  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> thread = [];

    var theValue = widget.forum['thread'];

    for(var i=0; i<theValue.length; i++){
      print(theValue);
      Map<String, dynamic> thread2 = Map<String, dynamic>.from(theValue[i]);
      thread.add(thread2);
    }

    List<LineOfChat> chats = [];
    for(var i=0; i<thread.length; i++){
      chats.add(LineOfChat(username: widget.forum['thread'][i]['username'], message: widget.forum['thread'][i]['message'], isMe: widget.forum['thread'][i]['username']==widget.theUsername,));
    }





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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Forum', style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700
                ),),
                ElevatedButton(onPressed: (){
                  print("Anu jajajjajajajaajaj");
                }, child:Icon(Icons.refresh, color: Color(0xFF3E5A81),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(CircleBorder()),
                    ),)
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: chats,
            ),
          )
        ],
      ),
    );
  }
}


class LineOfChat extends StatelessWidget {

 final String username;
 final String message;
 final bool isMe;

 LineOfChat({required this.username,required this.message,required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            username,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            color: isMe?Colors.yellow:Colors.red,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
