import 'package:flutter/material.dart';
import 'TextFormBuilder.dart';
import 'loginScreen.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String? _chosenValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3E5A81),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10.0),
              Center(
                child: Text('SAHAYYA',style: TextStyle(
                  fontFamily: 'Lobster',
                  color: Colors.white,
                  fontSize: 80.0,
                  letterSpacing: 5.5,
                ),),
              ),
              SizedBox(height: 30.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormBuilder(
                      enabled: true,
                      hintText: "Username",
                      textInputAction: TextInputAction.next,
                      myController: TextEditingController(),
                    ),
                    SizedBox(height: 40.0),
                    TextFormBuilder(
                      enabled: true,
                      hintText: "Email",
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 40.0),
                    TextFormBuilder(
                      enabled: true,
                      hintText: "Password",
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 40.0),
                    TextFormBuilder(
                      enabled: true,
                      hintText: "Confirm Password",
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 40.0),
                    Container(
                      height: 45.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Color(0xFF3E5A81),
                        boxShadow: [
                          BoxShadow(color: Colors.white70, spreadRadius: 1),
                        ],
                      ),
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          value: _chosenValue,
                          style: TextStyle(color: Colors.white),
                          dropdownColor: Color(0xFF3E5A81),
                          underline: Container(
                            height: 2,
                            color: Colors.transparent,
                          ),
                          iconSize: 50.0,
                          iconEnabledColor: Colors.white70,
                          isExpanded: true,
                          items: <String>[
                            'NGO',
                            'Company Donor',
                            'Individual Donor',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                              ),
                            );
                          }).toList(),
                          hint: Text(
                            "    Role",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              _chosenValue = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
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
                          fontSize: 23.0,
                          letterSpacing: 5.5,
                        ),),
                      ),decoration: BoxDecoration(

                        borderRadius:
                        BorderRadius.circular(20.0), ),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}