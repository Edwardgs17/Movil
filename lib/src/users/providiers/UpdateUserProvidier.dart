import 'dart:convert';

import 'package:colfunding/config/ConfigUri.dart';
import 'package:colfunding/utils/HttpClient.dart';
import 'package:http/http.dart';

class UpdateUserProvidier {
  HttpClient http;
  String uri;
  
  UpdateUserProvidier() {
    uri = ConfigUri().getUri();
    http = HttpClient();
  }

  Future<Map> getUserInformation(email) async {
    try {
      Response response = await http.get('$uri/users/$email');
      return jsonDecode(response.body);
    } catch (err) {
      return null;
    }
  }

  Future<Map> updateUser(email,data) async {
    try {
      Response response = await http.put('$uri/users/$email',data);
      return jsonDecode(response.body);
    } catch (err) {
      return null;
    }
  }

}