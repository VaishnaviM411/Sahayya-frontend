import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextNonEdit extends StatefulWidget {
  String label = '', text = '';

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
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '${widget.label}',
                    style: TextStyle(color: Color(0xFF3E5A81), fontSize: 12),
                  )
                ]),
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '${widget.text}',
                    style: TextStyle(
                        color: Color(0xFF3E5A81),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )
                ]),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          )),
    );
  }
}
