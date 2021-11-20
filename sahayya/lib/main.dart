import 'package:flutter/material.dart';
import 'package:sahayya/Company/companyDonor.dart';
import 'package:sahayya/Individual/individualDonor.dart';
import 'package:sahayya/loginScreen.dart';
import 'package:sahayya/NGO/ngoDashboard.dart';
import 'package:sahayya/pdfView.dart';
import 'package:sahayya/registerScreen.dart';
import 'startscreen.dart';
import 'registerScreen.dart';
import 'NGO/editProfile.dart';
import 'Company/editProfile.dart';
import 'Individual/editProfile.dart';
import 'NGO/giveOutDetails.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF3E5A81),
      ),
      initialRoute: '/start',
      routes: {
        '/start': (context) => StartScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => Register(),
        '/ngoDashboard': (context) => NGODashboard(),
        '/indvDonor': (context) => IndividualDonor(),
        '/compDonor': (context) => CompanyDonor(),
        '/editNGOProfile': (context) => EditNGOProfile(),
        '/editCompanyProfile': (context) => EditCompanyProfile(),
        '/editIndividualProfile': (context) => EditIndividualProfile(),
        '/giveOutDetails': (context) => GiveOutDetails(),
        '/pdf': (context) => PDFView()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
