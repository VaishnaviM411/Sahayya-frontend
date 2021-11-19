import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextNonEdit extends StatefulWidget {
  String label='', text='';

  TextNonEdit({required this.label, required this.text});

  @override
  _TextNonEditState createState() => _TextNonEditState();
}

class _TextNonEditState extends State<TextNonEdit> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
      child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),),
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Text('${widget.label}', style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF3E5A81)
              ),),
              Text('${widget.text}', style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF3E5A81),
                  fontWeight: FontWeight.bold
              ),),
              SizedBox(
                height: 5,
              ),
            ],
          )
      ),
    );
  }
}

