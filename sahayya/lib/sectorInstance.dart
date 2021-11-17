import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SectorInstance extends StatefulWidget {

  String secName="";
  Function deleteSectorInstance = () => "Hello World";

  SectorInstance(String secName, Function deleteSectorInstance){
    this.secName = secName;
    this.deleteSectorInstance = deleteSectorInstance;
  }

  @override
  _SectorInstanceState createState() => _SectorInstanceState();
}

class _SectorInstanceState extends State<SectorInstance> {




  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(

        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.circular(20.0),
          border: Border.all(color: Color(0xFF3E5A81)),
        ),
        child: Center(
            child:
        Text(widget.secName,
          style: TextStyle(color: Color(0xFF3E5A81)),)),

      ),
      onTap: (){
        widget.deleteSectorInstance(widget.secName);
      },
    );
  }
}

