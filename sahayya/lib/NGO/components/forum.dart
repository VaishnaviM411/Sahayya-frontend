import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Forum extends StatefulWidget {

  Map<dynamic,dynamic> userData = {}, forum = {};
  String theUsername = '', token='', id='';
  Function triggerUpdate = (){print("Hey");};

  Forum({required this.userData, required this.forum, required this.theUsername, required this.token, required this.id, required this.triggerUpdate});

  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {

  final messageTextController = TextEditingController();
  String? messageText;

  int randomSetStateVariable =0;
  void triggerUpdate2(){
    setState(() {
      randomSetStateVariable = 2;
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> thread = [];

    var theValue = widget.forum['thread'];

    for(var i=0; i<theValue.length; i++){
      Map<String, dynamic> thread2 = Map<String, dynamic>.from(theValue[i]);
      thread.add(thread2);
    }

    List<LineOfChat> chats = [];
    for(var i=0; i<thread.length; i++){
      chats.add(LineOfChat(username: theValue[i]['username'], message: theValue[i]['message'], isMe: theValue[i]['username']==widget.theUsername,));


      bool demo = false;
      if(theValue[i]['username'] == widget.theUsername){
        demo = true;
      }
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
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Forum', style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700
                ),),
              ],
            ),
          ),
          Container(
            height: 300,
            width: double.infinity,
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                chats,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white, width: 1.0),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageTextController,
                    minLines: 1,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      messageText = value;
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      hintText: 'Type your message here...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 15, 2),
                  child: ElevatedButton(
                    onPressed: () async{
                      Map<String, dynamic> theData = {
                        "message": messageTextController.text,
                        "username": widget.theUsername
                      };

                      final response = await http.post(
                          Uri.parse(
                              'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/add-comment/${widget.id}'),
                          headers: <String, String>{
                            'Content-Type':
                            'application/json; charset=UTF-8',
                            HttpHeaders.authorizationHeader: '${widget.token}'
                          },
                          body: json.encode(theData));

                      if(response.statusCode == 200){
                        final snackBar = SnackBar(
                          content: Text('Comment Added Successfully'),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar);
                        Navigator.pushNamed(context, '/ngoDashboard');
                        return;
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Color(0xFFFFFFFF), width: 2.0)))),
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: Color(0xFF3E5A81),
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            username,
            style: TextStyle(fontSize: 13.0, color: Colors.white, fontWeight: FontWeight.w700),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 3),
            child: Material(
              elevation: 5.0,
              borderRadius: isMe ? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ) : BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              color: isMe?Colors.white:Colors.white24,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  message,
                  style: TextStyle(color: isMe ? Colors.black:Colors.white, fontSize: 15.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
