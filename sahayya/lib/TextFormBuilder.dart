import 'package:flutter/material.dart';
import 'CustomCard.dart';

class TextFormBuilder extends StatefulWidget {
  final bool? enabled;
  final String? hintText;
  final TextInputAction? textInputAction;
  final TextEditingController? myController;
  final Key? key;

  TextFormBuilder(
      {this.enabled, this.hintText, this.textInputAction, this.key,this.myController});

  @override
  _TextFormBuilderState createState() => _TextFormBuilderState();
}

class _TextFormBuilderState extends State<TextFormBuilder> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCard(
            borderRadius: BorderRadius.circular(40.0),
            child: Container(
              child: Theme(
                data: ThemeData(
                  primaryColor: Color(0xFF3E5A81),
                ),
                child: TextFormField(
                  controller: widget.myController,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                  key: widget.key,
                  textInputAction: widget.textInputAction,
                  decoration: InputDecoration(
                      fillColor: Color(0xFF3E5A81),
                      filled: true,
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      border: border(context),
                      enabledBorder: border(context),
                      focusedBorder: focusBorder(context),
                      errorStyle: TextStyle(height: 0.0, fontSize: 0.0)),
                ),
              ),
            ),
          ),
          SizedBox(height: 5.0),
        ],
      ),
    );
  }

  border(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
      borderSide: BorderSide(
        color: Colors.white,
        width: 0.0,
      ),
    );
  }

  focusBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
      borderSide: BorderSide(
        color: Color(0xFFe0fcfb),
        width: 1.0,
      ),
    );
  }
}