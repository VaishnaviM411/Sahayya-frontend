import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const SERVER_IP = 'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/login';
final storage = FlutterSecureStorage();

class LoginBrain {
  Future<String?> loginAttempt(String username, String password) async {
    var res = await http.post(
      Uri.parse(SERVER_IP),
      body: {
        "username": username,
        "password": password,
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

