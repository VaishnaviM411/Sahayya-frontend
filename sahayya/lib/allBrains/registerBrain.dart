import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const SERVER_IP_NGO = 'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/ngo-signup';
const SERVER_IP_IND_DONOR = 'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/donor-individual-signup';
const SERVER_IP_COMP_DONOR = 'https://asia-south1-sahayya-9c930.cloudfunctions.net/api/donor-company-signup';