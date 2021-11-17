import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const SERVER_IP_NGO = 'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/ngo-signup';
const SERVER_IP_IND_DONOR = 'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/donor-individual-signup';
const SERVER_IP_COMP_DONOR = 'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/donor-company-signup';

final storage = FlutterSecureStorage();

class RegisterBrain {
  Future<String?> loginAttempt(String username, String password,String email,String cpassword) async {
    var res = await http.post(
      Uri.parse(SERVER_IP_NGO),
      body: {
        "username": username,
        "password": password,
        "cpassword":cpassword,
        "email":email,
      },
    );
    if(res.statusCode == 200) {
      var body = json.decode(res.body);
      print(body);
      return body['token'];
    }
    return null;
  }
}